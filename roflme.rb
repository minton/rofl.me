require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require "active_support/cache"

class Roflme < Sinatra::Base
  def rofls
    connection = Faraday.new(:url => 'http://knowyourmeme.com/search?utf8=%E2%9C%93&sort=score&q=rofl') do |conn|
      conn.response :caching do
        ActiveSupport::Cache::FileStore.new 'tmp/cache', :namespace => 'faraday', :expires_in => 3600
      end
      conn.adapter Faraday.default_adapter
    end
    response = connection.get
    doc = Nokogiri::HTML(response.body)
    doc.css("a.photo:not(.left) img").map{|img| {"rofl" => img["src"].gsub("medium", "large")}}
  end

  def others
    imgs = ['http://i.imgur.com/ndF9F0t.jpg',
            'http://i.imgur.com/DmcjGkc.jpg',
            'http://i.imgur.com/NW03x4N.jpg',
            'http://i.imgur.com/nKBupwC.jpg',
            'http://i.imgur.com/GS7f7OD.jpg',
            'http://i.imgur.com/PELjnWv.jpg',
            'http://i.imgur.com/ILk4lq9.jpg',
            'http://i.imgur.com/iIft4tX.jpg',
            'http://i.imgur.com/4PpmHzs.jpg',
            'http://i.imgur.com/oDzsGcq.jpg',
            'http://i.imgur.com/SyU7aMA.jpg',
            'http://i.imgur.com/ZszSTHz.jpg',
            'http://i.imgur.com/ffjri10.jpg',
            'http://i.imgur.com/AmK71N2.jpg',
            'http://i.imgur.com/XohJAtP.jpg',
            'http://i.imgur.com/U4OY9oK.jpg',
            'http://i.imgur.com/bprVQs5.jpg',
            'http://i.imgur.com/aGm3sTa.jpg',
            'http://i.imgur.com/cYZQP9U.jpg',
            'http://i.imgur.com/QaJmMJI.jpg',
            'http://i.imgur.com/Bd2mPl3.jpg',
            'http://i.imgur.com/MInBBSq.jpg',
            'http://i.imgur.com/rvUR8o8.jpg',
            'http://i.imgur.com/RawISVf.jpg',
            'http://i.imgur.com/RexkuPV.jpg',
            'http://i.imgur.com/2Uua94F.jpg',
            'http://i.imgur.com/MNu5GnT.jpg',
            'http://i.imgur.com/iSIj0La.jpg',
            'http://i.imgur.com/ciITCiM.jpg',
            'http://i.imgur.com/rvE6ufD.jpg',
            'http://i.imgur.com/F0rLuyV.jpg',
            'http://i.imgur.com/Dq2f5zl.jpg',
            'http://i.imgur.com/HQZV0DO.jpg',
            'http://i.imgur.com/KnxgscE.jpg',
            'http://i.imgur.com/aXl0t8x.jpg',
            'http://i.imgur.com/w6A7n8D.jpg',
            'http://i.imgur.com/EMeBbAz.jpg',
            'http://i.imgur.com/nYl2eiZ.jpg',
            'http://i.imgur.com/kMf7RKR.png',
            'http://i.imgur.com/1niTlRM.jpg',
            'http://i.imgur.com/7mA3RbY.jpg',
            'http://i.imgur.com/7mA3RbY.jpg',
            'http://i.imgur.com/qd2CtKt.jpg']
    {"rofl" => imgs.sample}
  end

  before do
    content_type :json
  end

  get '/' do
    rofls.to_json
  end
  get '/random' do
    if rand(60) % 2 == 0
      others.to_json
    else
      rofls.sample.to_json
    end
  end

end