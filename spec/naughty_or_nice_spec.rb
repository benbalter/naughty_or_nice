RSpec.describe NaughtyOrNice do
  let(:domain) { 'example.com' }
  subject { TestHelper.new(domain) }

  # Test case => expected response
  {
    'foo@github.gov'     => 'github.gov',
    'foo.github.gov'     => 'foo.github.gov',
    'http://github.gov'  => 'github.gov',
    'https://github.gov' => 'github.gov',
    '.gov'               => '.gov',
    'foo'                => nil
  }.each do |input, expected|
    context "when given #{input}" do
      let(:domain) { input }

      it 'parses the domain' do
        expect(subject.send(:domain_text)).to eql(expected)
      end
    end
  end

  context 'when given a PublicSuffix::Domain' do
    let(:domain) { PublicSuffix.parse('foo.gov') }

    it 'parses the domain' do
      expect(subject.domain.to_s).to eql('foo.gov')
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
  end

  context 'when given an invalid domain' do
    let(:domain) { 'foo@gov.invalid' }

    it "doesn't blow up" do
      expect(subject.domain).to be_nil
      expect(subject.to_s).to be_nil

      expect(TestHelper.valid?(domain)).to eql(false)
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
        expect { subject.domain }.to_not raise_error
      end
    end

    context 'when given an invalid email' do
      let(:domain) { ':foo@bar.gov' }

      it "doesn't error" do
        expect { subject.domain }.to_not raise_error
      end
    end
  end
end
