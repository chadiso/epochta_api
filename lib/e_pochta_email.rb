module EPochtaService
	class EPochtaEmail < EPochtaBase
		URL = 'http://atompark.com/api/email/3.0/'

		[
				:addAddressbook, :delAddressbook, :addAddresses,
				:getAddressbook, :activateEmails, :createCampaign,
				:delEmail, :getUserBalance, :getCampaignStats, :getTemplates
		].each do |method|
			define_method(method) do |params|
				params['action'] = method.to_s
				result = exec_command(params)
				STDERR.puts result.body
				result = JSON.parse(result.body)

				if result.include? 'error'
					false
				else
					result.include?('result') ? result['result'] : result
				end
			end
		end

		# calling API's addAddressesNew method
		def addAddressesNew(params)

			if (params['id_list'].present? && params['emails'].kind_of?(Array) && params['emails'].count)

				p = {
						'action' => 'addAddressesNew',
						'id_list' => params['id_list'].kind_of?(Array) ? params['id_list'] : [params['id_list'].to_i]
				}

				# emails
				p['emails'] = {
						'address' => params['emails'].kind_of?(Array) ? params['emails'].join('|') : params['emails'].to_s
				}

				#variables

				if (params['variables'].kind_of?(Array) && params['variables'].count)
					p['emails']['variables'] = params['variables'].each { |var| var.to_json }.join('|')
				end


				p['version'] = '3.0'
				p['sum'] = calculate_md5 p
				self.parameters = p.each { |k, v| v = URI.escape v.to_s }

				# Because of standard URI module doesn't correctly interpret arrays and hashes,
				# we are using Addressable gem
				uri = Addressable::URI.new
				uri.query_values= p # p.reject {|k,e| %w(action version).include?(k) }

				url = URI("#{self.class::URL}#{p['action']}")
				url.query = uri.query

				result = Net::HTTP.post_form(url, self.parameters)
				STDERR.puts result.body
				result = JSON.parse(result.body)

				if result.include? 'error'
					false
				else
					result.include?('result') ? result['result'] : result
				end
			else
				return false

			end

		end


		def getCampaignDeliveryStats(params)
			params['action'] = 'getCampaignDeliveryStats'	
			result = exec_command(params)
			
			result = JSON.parse(result.body)
			
			if result.has_key? 'error'							
				false
			else					
				fetch_statuses result['result']
			end		
		end	

		private

		def fetch_statuses(raw_statuses)
			#raw status is an array ['email@example.com', 1, #DateTime#]
			statuses = {}
			raw_statuses.each {|status_array| statuses[status_array[0]] = status_array[1] }
			return statuses			
		end	
	end
end