
heroku run rails runner "
HappyCustomerCompany.find_each do |c|
  norm = c.company_name.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
  c.update_columns(company_name_normalized: norm)
end
" -a happy-erp-prod

