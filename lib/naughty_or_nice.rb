require 'public_suffix'
require "addressable/uri"
require_relative './naughty_or_nice/version'

module NaughtyOrNice

  # Source: http://bit.ly/1n2X9iv
  EMAIL_REGEX = %r{
        ^
        (
          [\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+
          \.
        )
        *
        [\w\!\#\$\%\&\'\*\+\-\/\=\?\^\`\{\|\}\~]+
        @
        (
          (
            (
              (
                (
                  [a-z0-9]{1}
                  [a-z0-9\-]{0,62}
                  [a-z0-9]{1}
                )
                |
                [a-z]
              )
              \.
            )+
            [a-z]{2,6}
          )
          |
          (
            \d{1,3}
            \.
          ){3}
          \d{1,3}
          (
            \:\d{1,5}
          )?
        )
        $
      }xi

  module ClassMethods
    def valid?(text)
      self.new(text).valid?
    end
  end

  # Ruby idiom that allows `include` to create class methods
  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(domain)
    if domain.is_a?(PublicSuffix::Domain)
      @domain = domain
      @text   = domain.to_s
    else
      @text = domain.to_s.downcase.strip
    end
  end

  # Return the public suffix domain object
  #
  # Supports all domain strings (URLs, emails)
  #
  # Returns the domain object or nil, but no errors, never an error
  def domain
    @domain ||= PublicSuffix.parse(domain_text)
  rescue PublicSuffix::DomainInvalid, PublicSuffix::DomainNotAllowed
    nil
  end

  # Checks if the input string represents a valid domain
  #
  # Returns boolean true if a valid domain, otherwise false
  def valid?
    !!(domain && domain.valid?)
  end

  # Is the input text in the form of a valid email address?
  #
  # Returns true if email, otherwise false
  def email?
    !!(@text =~ EMAIL_REGEX)
  end

  # Return the parsed domain as a string
  def to_s
    @to_s ||= domain.to_s if domain
  end

  def inspect
    "#<#{self.class} domain=\"#{domain}\" valid=#{valid?}>"
  end

  private

  # Parse the domain from the input string
  #
  # Can handle urls, domains, or emails
  #
  # Returns the domain string
  def domain_text
    return nil if @text.empty?

    uri = Addressable::URI.parse(@text)

    if uri.host # valid https?://* URI
      uri.host
    elsif email?
      @text.match(/@([\w\.\-]+)\Z/i)[1]
    else # url sans http://
      uri = Addressable::URI.parse("http://#{@text}")
      # properly parse http://foo edge cases
      # see https://github.com/sporkmonger/addressable/issues/145
      uri.host if uri.host =~ /\./
    end
  rescue Addressable::URI::InvalidURIError
    nil
  end
end
