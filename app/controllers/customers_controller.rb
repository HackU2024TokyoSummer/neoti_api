class CustomersController < ApplicationController
  # customerを登録する
  def main
    user = User.find_by(email: params[:email])
    endpoint = "/v1/customers"
    uri = URI.parse(ENV['BASE_URL'] + endpoint)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    user

    data = {
      email: user.email,
    }

    # リクエストの作成
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{ENV['API_KEY']}"
    request['Content-Type'] = 'application/json'

    request.body = data.to_json

    # リクエストの送信
    response = http.request(request)

    case response
    when Net::HTTPSuccess
      response_data = JSON.parse(response.body)
      customer_id = response_data['id']
      if customer_id
        #
        # IDをデータベースに保存
        # @current_user.update(external_customer_id: customer_id)
        result = Customer.create!(customer_fincode_id: customer_id, user_id: user.id)
        puts "SUCCESS: Customer ID #{result.customer_fincode_id} saved to database"
      else
        puts "ERROR: Customer ID not found in response"
      end

    else
      puts 'ERROR'
    end

    # レスポンスの表示
    puts response.body

    endpoint2 = "/v1/customers/#{customer_id}/payment_methods"

    uri = URI.parse(ENV['BASE_URL'] + endpoint2)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    data = {
      pay_type: "Card",
      default_flag: "1",
    }

    # リクエストの作成
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{ENV['API_KEY']}"
    request['Content-Type'] = 'application/json'

    request.body = data.to_json

    # リクエストの送信
    response2 = http.request(request)

    case response2
    when Net::HTTPSuccess
      puts 'SUCCESS'
    else
      puts 'ERROR'
    end

    # レスポンスの表示
    puts response2.body


  end

  # カード登録
  def card
    user = User.find_by(email: params[:email])
    endpoint = "/v1/customers/#{user.customer.customer_fincode_id}/cards"
    uri = URI.parse(ENV['BASE_URL'] + endpoint)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    data = {
      token: params[:token],
      default_flag: '1'
    }

    # リクエストの作成
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Authorization'] = "Bearer #{ENV['API_KEY']}"
    request['Content-Type'] = 'application/json'

    request.body = data.to_json
    # リクエストの送信
    response = http.request(request)
    case response
    when Net::HTTPSuccess
      puts 'SUCCESS'
    else
      puts 'ERROR'
    end
    # レスポンスの表示
    puts response.body
  end

  #決済実行
  def register
    user = User.find_by(email: params[:email])
    order_id = params[:order_id]
    endpoint = "/v1/payments/#{order_id}"
    # query_params =  {
    #   pay_type: 'Card',
    # }

    uri = URI.parse(ENV['BASE_URL'] + endpoint)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    data = {
      pay_type: "Card",
      access_id: params[:access_id],
      card_id: "cs_grSZR_KuQTWxmY2q5ckEJQ",
      customer_id: "c_L99T0pz8R4ueI0EJwP5J-g",
      method: "1"
    }

    # リクエストの作成
    request = Net::HTTP::Put.new(uri.request_uri)
    request['Authorization'] = "Bearer #{ENV['API_KEY']}"
    request['Content-Type'] = 'application/json'

    request.body = data.to_json

    # リクエストの送信
    response = http.request(request)

    case response
    when Net::HTTPSuccess
      puts 'SUCCESS'
    else
      puts 'ERROR'
    end

    # レスポンスの表示
    puts response.body
  end

  # def auth
  #   access_id = 'a_NLsLdCyLS_KGIM5sGWi0kQ'
  #   endpoint = "/v1/secure2/#{access_id}"
  #   uri = URI.parse(ENV['BASE_URL'] + endpoint)
  #
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #
  #   data = {
  #     param: '<Value you received in tds2_ret_url>'
  #   }
  #
  #   # リクエストの作成
  #   request = Net::HTTP::Put.new(uri.request_uri)
  #   request['Authorization'] = "Bearer #{API_KEY}"
  #   request['Content-Type'] = 'application/json'
  #
  #   request.body = data.to_json
  #
  #   # リクエストの送信
  #   response = http.request(request)
  #
  #   case response　
  #   when Net::HTTPSuccess
  #     puts 'SUCCESS'
  #   else
  #     puts 'ERROR'
  #   end
  #
  #   # レスポンスの表示
  #   puts response.body
  # end

end
