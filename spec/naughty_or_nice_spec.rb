# frozen_string_literal: true

RSpec.describe NaughtyOrNice do
  subject { TestHelper.new(domain) }

  let(:domain) { 'example.com' }

  # Test case => expected response
  {
    'foo@github.gov' => 'github.gov',
    'foo.github.gov' => 'foo.github.gov',
    'http://github.gov' => 'github.gov',
    'https://github.gov' => 'github.gov',
    '.gov' => '.gov',
    'foo' => nil,
    'http://foo' => nil
  }.each do |input, expected|
    context "when given #{input}" do
      let(:domain) { input }

      it 'normalizes the domain' do
        expect(subject.send(:normalized_domain)).to eql(expected)
      end

      it 'parses the domain' do
        if expected.nil?
          expect(subject.send(:parsed_domain)).to be_nil
        else
          expect(subject.send(:parsed_domain).host).to eql(expected)
        end
      end
    end
  end

  context 'when given a PublicSuffix::Domain' do
    let(:domain) { PublicSuffix.parse('foo.gov') }

    it 'parses the domain' do
      expect(subject.domain.to_s).to eql('foo.gov')
    end

    it 'knows the domain is valid' do
      expect(subject.valid?).to be(true)
    end

    it "knows it's not an email" do
      expect(subject.email?).to be(false)
    end
  end

  context 'when given a string' do
    let(:domain) { 'foo.gov' }

    it 'returns the domain' do
      expect(subject.domain.to_s).to eql(domain)
    end

    it 'returns the domain string' do
      expect(subject.to_s).to eql(domain)
    end

    it 'returns the PublicSuffix::Domain' do
      expect(subject.domain).to be_a(PublicSuffix::Domain)
    end

    it 'knows the domain is valid' do
      expect(subject.valid?).to be(true)
    end

    it "knows it's not an email" do
      expect(subject.email?).to be(false)
    end
  end

  context 'when given an invalid domain' do
    let(:domain) { 'foo@gov.invalid' }

    it "doesn't blow up" do
      expect(subject.domain).to be_nil
      expect(subject.to_s).to be_nil

      expect(TestHelper.valid?(domain)).to be(false)
    end

    it 'knows the domain is invalid' do
      expect(subject.valid?).to be(false)
    end
  end

  context 'when given an email' do
    let(:domain) { 'foo@bar.gov' }

    it "knows it's an email" do
      expect(subject.email?).to be(true)
    end
  end

  context 'parsing domain parts' do
    context 'when given foo@bar.gov' do
      let(:domain) { 'foo@bar.gov' }

      it 'returns the tld' do
        expect(subject.domain.tld).to eql('gov')
      end

      it 'returns the sld' do
        expect(subject.domain.sld).to eql('bar')
      end
    end

    context 'when given https://foo.bar.gov' do
      let(:domain) { 'https://foo.bar.gov' }

      it 'parses the tld' do
        expect(subject.domain.tld).to eql('gov')
      end

      it 'parses the sld' do
        expect(subject.domain.sld).to eql('bar')
      end
    end

    context 'when given foo@bar.gov' do
      let(:domain) { 'foo@bar.gov' }

      it 'parses the domain' do
        expect(subject.domain.domain).to eql('bar.gov')
      end
    end
  end

  context 'invalid domains' do
    context 'when given an invalid host' do
      let(:domain) { '</@foo.com' }

      it "doesn't error" do
        expect { subject.domain }.not_to raise_error
      end

      it 'knows the domain is invalid' do
        expect(subject.valid?).to be(false)
      end
    end

    context 'when given an invalid email' do
      let(:domain) { 'foo@bar' }

      it "doesn't error" do
        expect { subject.domain }.not_to raise_error
      end

      it 'knows the domain is invalid' do
        expect(subject.valid?).to be(false)
      end
    end
  end
end
