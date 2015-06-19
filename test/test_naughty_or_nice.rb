require 'helper'

class TestNaughtyOrNice < Minitest::Test

  should "properly parse domains from strings" do
    assert_equal "github.gov", NaughtyOrNice.new("foo@github.gov").domain
    assert_equal "foo.github.gov", NaughtyOrNice::new("foo.github.gov").domain
    assert_equal "github.gov", NaughtyOrNice::new("http://github.gov").domain
    assert_equal "github.gov", NaughtyOrNice::new("https://github.gov").domain
    assert_equal ".gov", NaughtyOrNice::new(".gov").domain
    assert_equal nil, NaughtyOrNice.new("foo").domain
  end

  should "not err out on invalid domains" do
    assert_equal false, NaughtyOrNice.valid?("foo@gov.invalid")
    assert_equal "gov.invalid", NaughtyOrNice.new("foo@gov.invalid").domain
    assert_equal nil, NaughtyOrNice.new("foo@gov.invalid").domain_parts
  end

  should "return public suffix domain" do
    assert_equal PublicSuffix::Domain, NaughtyOrNice.new("whitehouse.gov").domain_parts.class
    assert_equal NilClass, NaughtyOrNice.new("foo.invalid").domain_parts.class
  end

  should "parse domain parts" do
    assert_equal "gov", NaughtyOrNice.new("foo@bar.gov").domain_parts.tld
    assert_equal "bar", NaughtyOrNice.new("foo.bar.gov").domain_parts.sld
    assert_equal "bar", NaughtyOrNice.new("https://foo.bar.gov").domain_parts.sld
    assert_equal "bar.gov", NaughtyOrNice.new("foo@bar.gov").domain_parts.domain
  end

  should "not err out on invalid hosts" do
    assert_equal nil, NaughtyOrNice.new("</@foo.com").domain
  end

  should "not err out on invalid email addresses" do
    assert_equal nil, NaughtyOrNice.new(":foo@bar.gov").domain
  end
end
