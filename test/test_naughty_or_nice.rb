require 'helper'

class TestTestHelper < Minitest::Test

  should "properly parse domains from strings" do
    assert_equal "github.gov", TestHelper.new("foo@github.gov").domain
    assert_equal "foo.github.gov", TestHelper::new("foo.github.gov").domain
    assert_equal "github.gov", TestHelper::new("http://github.gov").domain
    assert_equal "github.gov", TestHelper::new("https://github.gov").domain
    assert_equal ".gov", TestHelper::new(".gov").domain
    assert_equal nil, TestHelper.new("foo").domain
  end

  should "accept PublicSuffix::Domains" do
    domain = PublicSuffix.parse("foo.gov")
    assert_equal "foo.gov", TestHelper.new(domain).domain
  end

  should "not err out on invalid domains" do
    assert_equal false, TestHelper.valid?("foo@gov.invalid")
    assert_equal "gov.invalid", TestHelper.new("foo@gov.invalid").domain
    assert_equal nil, TestHelper.new("foo@gov.invalid").domain_parts
  end

  should "return public suffix domain" do
    assert_equal PublicSuffix::Domain, TestHelper.new("whitehouse.gov").domain_parts.class
    assert_equal NilClass, TestHelper.new("foo.invalid").domain_parts.class
  end

  should "parse domain parts" do
    assert_equal "gov", TestHelper.new("foo@bar.gov").domain_parts.tld
    assert_equal "bar", TestHelper.new("foo.bar.gov").domain_parts.sld
    assert_equal "bar", TestHelper.new("https://foo.bar.gov").domain_parts.sld
    assert_equal "bar.gov", TestHelper.new("foo@bar.gov").domain_parts.domain
  end

  should "not err out on invalid hosts" do
    assert_equal nil, TestHelper.new("</@foo.com").domain
  end

  should "not err out on invalid email addresses" do
    assert_equal nil, TestHelper.new(":foo@bar.gov").domain
  end
end
