module BlogSite
  class API < Grape::API
    version 'v1', using: :header, vendor: 'wewin'
    format :json
    prefix :api
    mount BlogSite::Auth
    mount BlogSite::Articles
  end
end
