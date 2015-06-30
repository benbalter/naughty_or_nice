require 'public_suffix'
require "addressable/uri"

class NaughtyOrNice

  class << self
    def valid?(text)
      self.new(text).valid?
    end
  end

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

  def initialize(domain)
    if domain.is_a?(PublicSuffix::Domain)
      @domain_parts = domain
      @text = domain.to_s
    else
      @text = domain.to_s.downcase.strip
    end
  end

  # Parse the domain from the input string
  #
  # Can handle urls, domains, or emails
  #
  # Returns the domain string
  def domain
    @domain ||= begin
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
  alias_method :to_s, :domain

  # Checks if the input string represents a valid domain
  #
  # Returns boolean true if a valid domain, otherwise false
  def valid?
    !!(domain_parts && domain_parts.valid?)
  end

  # Is the input text in the form of a valid email address?
  #
  # Returns true if email, otherwise false
  def email?
    !!(@text =~ EMAIL_REGEX)
  end

  # Helper function to return the public suffix domain object
  #
  # Supports all domain strings (URLs, emails)
  #
  # Returns the domain object or nil, but no errors, never an error
  def domain_parts
    @domain_parts ||= begin
      PublicSuffix.parse domain
    rescue PublicSuffix::DomainInvalid, PublicSuffix::DomainNotAllowed
      nil
    end
  end

  def inspect
    "#<#{self.class} domain=\"#{domain}\" valid=#{valid?}>"
  end
end
