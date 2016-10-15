require 'helper'

class TestTestHelper < Minitest::Test
  should 'properly parse domains from strings' do
    assert_equal 'github.gov', TestHelper.new('foo@github.gov').send(:domain_text)
    assert_equal 'foo.github.gov', TestHelper.new('foo.github.gov').send(:domain_text)
    assert_equal 'github.gov', TestHelper.new('http://github.gov').send(:domain_text)
    assert_equal 'github.gov', TestHelper.new('https://github.gov').send(:domain_text)
    assert_equal '.gov', TestHelper.new('.gov').send(:domain_text)
    assert_equal nil, TestHelper.new('foo').send(:domain_text)
  end

  should 'accept PublicSuffix::Domains' do
    domain = PublicSuffix.parse('foo.gov')
    assert_equal 'foo.gov', TestHelper.new(domain).domain.to_s
  end

  should 'accept string domains' do
    assert_equal 'foo.gov', TestHelper.new('foo.gov').domain.to_s
  end

  should 'return the domain string' do
    assert_equal 'foo.gov', TestHelper.new('foo.gov').to_s
  end

  should 'not err out on invalid domains' do
    assert_equal false, TestHelper.valid?('foo@gov.invalid')
    assert_equal nil, TestHelper.new('foo@gov.invalid').domain
    assert_equal nil, TestHelper.new('foo@gov.invalid').to_s
  end

  should 'return public suffix domain' do
    assert_equal PublicSuffix::Domain, TestHelper.new('whitehouse.gov').domain.class
    assert_equal NilClass, TestHelper.new('foo.invalid').domain.class
  end

  should 'parse domain parts' do
    assert_equal 'gov', TestHelper.new('foo@bar.gov').domain.tld
    assert_equal 'bar', TestHelper.new('foo.bar.gov').domain.sld
    assert_equal 'bar', TestHelper.new('https://foo.bar.gov').domain.sld
    assert_equal 'bar.gov', TestHelper.new('foo@bar.gov').domain.domain
  end

  should 'not err out on invalid hosts' do
    assert_equal nil, TestHelper.new('</@foo.com').domain
  end

  should 'not err out on invalid email addresses' do
    assert_equal nil, TestHelper.new(':foo@bar.gov').domain
  end
end
