require 'spec_helper'

describe LinkData::Meta::Extractor do
  let(:parsed_body) { ::Nokogiri::HTML.parse(body) }
  let(:link_data) { LinkData.new }
  let(:extractor) { LinkData::Meta::Extractor.new(parsed_body, link_data) }

  let(:body) {
    "<html>
      <head>
        <meta property=\"og:title\" content=\"This is a title\">
        <meta property=\"og:description\" content=\"A description for your face\">
        <meta property=\"og:image\" content=\"http://imageurl.com\">
        <meta name=\"Description\" content=\"Here is a description not for facebook\">
        <meta name=\"KEYWORDS\"    content=\"Keywords, Keywords everywhere\">
        <title>TITLE!</title>
        <meta itemprop='thumbnailUrl' name='thumbnail' content='http://imageurlfrommeta.com'>
      </head>
    </html>"
  }

  describe 'perform' do
    context 'there is no og_data' do
      let(:body) {
        "<html>
        <head>
        </head>
      </html>"
      }

      it 'should fail quietly' do
        expect { extractor.perform }.to_not raise_error
      end
    end

    context 'there is og_data' do
      it 'should return a populated LinkPreview object' do
        extractor.perform
        link_data.meta.title.should == 'TITLE!'
        link_data.meta.image_url.should == "http://imageurlfrommeta.com"
        link_data.meta.description.should == 'Here is a description not for facebook'
      end
    end
  end
end