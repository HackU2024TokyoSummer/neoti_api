class CustomersController < ApplicationController
  # customerを登録する
  def main
    endpoint = "/v1/customers"
    uri = URI.parse(ENV['BASE_URL'] + endpoint)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    user

    data = {
      name: @current_user.name,
      email: @current_user.email,
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
        # IDをデータベースに保存
        # @current_user.update(external_customer_id: customer_id)
        result = Customer.create!(customer_fincode_id: customer_id, user_id: @current_user.id)
        puts "SUCCESS: Customer ID #{result.customer_fincode_id} saved to database"
      else
        puts "ERROR: Customer ID not found in response"
      end

    else
      puts 'ERROR'
    end

    # レスポンスの表示
    puts response.body
  end

  def id

  end
end
