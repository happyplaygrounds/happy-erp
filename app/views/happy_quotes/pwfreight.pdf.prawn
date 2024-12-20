
# playworldFreight.pdf.prawn

test = "PWfreight-"+@happyvendor.vendor_name+"-"+@happyvendor.id.to_s+"-"+@happyquote.id.to_s+"-"+DateTime.now.strftime('%m-%d-%Y-%H%M%S').to_s+".pdf"

#test = @happyquote.happy_customer.customer_name+"-"+@happyquote.id.to_s+"-"+DateTime.now.in_time_zone("Central Time (US & Canada)").strftime('%m-%d-%Y-%H%M%S').to_s+".pdf"
#test = "tmp/test.pdf"

prawn_document(filename: test, disposition: "attachment") do |pdf|
#prawn_document() do |pdf|

  logopath = 'HP_Logo.jpg'     
  initial_y = pdf.cursor       
  initialmove_y = 5            
  address_x = 0                
  freight_table1_x = 0         
  freight_table2_x = 325         
  quote_header_x = 325         
  quote_certs_x = 355          
  lineheight_y = 12            
  font_size = 9                
  
  #pdf.move_down initialmove_y  
  ####
  
        #pdf.text pdf.cursor, :size => 14
        # header
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.top], :width  => pdf.bounds.width do
          
  		pdf.text "PLAYWORLD FREIGHT QUOTE FORM", align: :center, size: 14, style: :bold
  		pdf.fill_color "0093DD"
  		pdf.text "freight@playworld.com", align: :center, size: 12, style: :bold
  		pdf.fill_color "000000"
  		pdf.text "LTL FREIGHT QUOTES VALID FOR 60 DAYS", align: :center, size: 14, style: :bold
  		pdf.text "Truckload/Direct Ship Quotes Valid 30 DAYS", align: :center, size: 14, style: :bold
                pdf.move_down 12

  $submitted_by = @username.gsub(/\./,' ')

  table1_header_data = [ 
    ["DISTRIBUTOR:", "Happy Playgrounds"],
    ["SUBMITTED BY:", $submitted_by],
    ["DATE:", " "]
  ]

  pdf.table(table1_header_data, :position => freight_table1_x, :width => 280, :cell_style => { :size => 10 }) do
    style(row(0..2).columns(0..1), :padding => [1, 5, 1, 5], :borders => [:top, :left, :right, :bottom])
    style(column(1), :align => :left, :width => 172)
  end

  pdf.move_down 12
  $cityState =  @happyquote.shipping_city + ", " + @happyquote.shipping_state;
  puts ($cityState)

  table1_header_data = [ 
    ["CONSIGNEE NAME: ", @happyquote.happy_customer.customer_name],
    ["CITY & STATE: ", $cityState],
    ["CONTACT:", " "],
    ["EMAIL: ", @useremail]
  ]

  pdf.table(table1_header_data, :position => freight_table1_x, :width => 280, :cell_style => { :size => 10 }) do
    style(row(0..2).columns(0..1), :padding => [1, 5, 1, 5], :borders => [:top, :left, :right, :bottom])
    style(column(1), :align => :left)
  end

  pdf.move_cursor_to 60.0
  $address =  @happyquote.shipping_street1 +  @happyquote.shipping_street2;

  table1_header_data = [ 
    ["ADDRESS:", $address],
    ["ZIP CODE:", @happyquote.shipping_zipcode],
    ["TELEPHONE:", " "],
  ]

  pdf.table(table1_header_data, :position => freight_table2_x, :width => 225, :cell_style => { :size => 10 }) do
    style(row(0..2).columns(0..1), :padding => [1, 5, 1, 5], :borders => [:top, :left, :right, :bottom])
    style(column(1), :align => :left, :width => 152)
  end


  pdf.move_down 20

    end # end bounding box for header

  ###
  # Add the font style and size
  pdf.font "Helvetica"         
  pdf.font_size font_size  

     #body
     pdf.move_down 20
     #pdf.text pdf.bounds.top, :size => 14
     pdf.bounding_box [pdf.bounds.left, (pdf.bounds.top - 220)], :width  => pdf.bounds.width + 30, :height => 580 do
     pdf.text "FREIGHT DETAILS:", align: :center, size: 11, style: :bold
     #pdf.text "(ATTACH BOM, DRAWING, OR PRICING SCHEDULE LISTING ALL PRODUCT TO BE SHIPPED BY PLAYWORLD)", align: :center, size: 10
     pdf.fill_color "ffff00"
     pdf.fill_rectangle [0,570], 540, 16
     pdf.fill_color "000000"
     pdf.text '(ATTACH BOM, DRAWING, OR PRICING SCHEDULE LISTING ALL PRODUCT TO BE SHIPPED BY PLAYWORLD)', align: :center, size: 10
     #pdf.fill_rectangle [0,600], 200, 100

     quote_items_header = ["QTY:", "PRODUCT & DESCRIPTION","WT:"]
     quote_items_header2 = ["QTY:", "FREE FREIGHT ITEMS","WT:"]

  quote_items_data = []
  quote_items_data << quote_items_header
  quote_items_data2 = []
  quote_items_data2 << quote_items_header2

  $loopCount = 0;
  $weight = 0;
  $loopCount2 = 0;
  $weight2 = 0;
  @happyquote.happy_quote_lines.map.with_index do |item, index|
                puts("loop #$loopCount");
                puts("index #{index}");
                puts("#{@happyquote.happy_quote_lines.size}");
                $last_row = @happyquote.happy_quote_lines.size + 1
                puts("last_row #{$last_row}");
                #if $loopCount <= 14
                  if not item.active
		  	number_with_precision($weight, :precision => 2, :delimiter => ',')
           	  	quote_items_data << [ item.quantity, item.product_id,number_with_precision((item.weight*item.quantity), :precision => 2, :delimiter => ',') ]
                	$weight = $weight + (item.weight*item.quantity) 
			
           	   	quote_items_data2 << [ " ", " "," " ]
                	$loopCount +=1;
                  else
		  	number_with_precision($weight, :precision => 2, :delimiter => ',')
           	  	quote_items_data2 << [ item.quantity, item.product_id,number_with_precision((item.weight*item.quantity), :precision => 2, :delimiter => ',') ]
                	$weight2 = $weight2 + (item.weight*item.quantity) 
           	   	quote_items_data << [ " ", " "," " ]
                	$loopCount2 +=1;
           	  	#quote_items_data2 << [ item.quantity, item.product_id,(item.weight*item.quantity) ]
           	  end
                #end

  end

  #$remainingCells = 14 - $loopCount

  #$i=0

  #while $i < $remainingCells do 
  #              if $i < (14 - $loopCount)
  #         	   quote_items_data << [ " ", " "," " ]
  #              end
  #     $i +=1
  #end

  #$remainingCells2 = 14 - $loopCount2

  #$i=0

  #while $i < $remainingCells2 do 
  #              if $i < (14 - $loopCount2)
  #         	   quote_items_data2 << [ " ", " "," " ]
  #              end
  #     $i +=1
  #end



           	  	quote_items_data << [ " ", "TOTAL WEIGHT:", number_with_precision($weight, :precision => 2, :delimiter => ',') ]
           	  	quote_items_data2 << [ " ", "TOTAL WEIGHT:",number_with_precision($weight2, :precision => 2, :delimiter => ',') ]
  		#pdf.fill_color "000000"
          

     last_measured_y = pdf.cursor

  pdf.table(quote_items_data, :width =>  250, :header => true) do
    style(row(1..-1).columns(0..-1), :padding => [1, 5, 1, 5], :borders => [:top, :right, :bottom, :left])
    style(row(0), :font_style => :bold)
    style(row(0).columns(0..-1), :borders => [:top, :left, :right, :bottom])
    style(row(0).columns(0), :borders => [:top, :left, :bottom])
  #  style(row(-1), :border_width => 10)
    style(column(1..-1), :align => :left)
    style(column(3..-1), :align => :left)
    style(column(4..-1), :align => :left)
    style(column(5..-1), :align => :left)
    style(column(6..-1), :align => :left)
    style(columns(0), :width => 50)
    style(columns(1), :width => 140)
    style(columns(2), :width => 60)
    style(row($last_row).columns(1), :text_color => 'FF0000',  :align => :right)
  end

     pdf.move_cursor_to last_measured_y 

  pdf.table(quote_items_data2, :width =>  250, :position => 280, :header => true) do
    style(row(1..-1).columns(0..-1), :padding => [1, 5, 1, 5], :borders => [:top, :right, :bottom, :left])
    style(row(0), :font_style => :bold)
    style(row(0).columns(1), :background_color => '1bfc06')
    style(row(0).columns(0..-1), :borders => [:top, :left, :right, :bottom])
    style(row(0).columns(0), :borders => [:top, :left, :bottom])
  #  style(row(-1), :border_width => 10)
    style(column(1..-1), :align => :left)
    style(column(3..-1), :align => :left)
    style(column(4..-1), :align => :left)
    style(column(5..-1), :align => :left)
    style(column(6..-1), :align => :left)
    style(columns(0), :width => 50)
    style(columns(1), :width => 140)
    style(columns(2), :width => 60)
    style(row($last_row).columns(1), :text_color => 'FF0000',  :align => :right)
  end


            weight_total = [] 
            weight_total << [number_with_precision($weight, :precision => 2, :delimiter => ','), number_with_precision($weight2, :precision => 2, :delimiter => ',') ]

	pdf.table(weight_total, :width =>  200, :position => 180, :header => false) do
          style(columns(0), :width => 100)
          style(column(0..-1), :align => :center)
        end


     if pdf.cursor < 350
        #pdf.text pdf.cursor, :size => 14
        pdf.start_new_page
        #pdf.stroke_horizontal_rule
        subtotal_y = 500 
        pdf.move_cursor_to 770 
        puts ("TOP");
     else
        #pdf.text pdf.cursor, :size => 14
        subtotal_y = pdf.cursor - 25 
        puts ("BOTTOM");
     end

     #pdf.text "bottom before end", align: :center, size: 12, style: :bold

     last_measured_y = pdf.cursor

     #pdf.text "top after end", align: :center, size: 12, style: :bold

     pdf.move_down 20

     pdf.text "DELIVERY DETAILS:", align: :center, size: 12, style: :bold


  debug(params)
  table3_header_data = [ 
    ["LIFTGATE? ONLY GOOD ON LTL -6-1/2' OR LESS", "N"],
    ["INSIDE DELIVERY?", "N"],
    ["CALL BEFORE?", "Y"],
    ["RESIDENTIAL/BUSINESS/SCHOOL/CHURCH/MILITARY BASE?", @type_of_business],
    ["CAN FULL SIZE TRAILER DELIVER?", "Y"],
    ["DELIVERY DATE REQUIRED?", "N"],
    ["STANDARD/EXPEDITED/GUARANTEED DELVY?", "N"],
    ["LIMITED HOURS FOR DELIVERY?", "N"],
    ["OTHER?", ""]
  ]

  pdf.table(table3_header_data, :position => freight_table1_x, :width => 475) do
    style(row(0..2).columns(0..1), :padding => [1, 5, 1, 5], :borders => [:top, :left, :right, :bottom])
    style(column(0), :align => :center)
  end

                pdf.move_down 20
     pdf.draw_text "PLAYWORLD USE:", :at => [130, pdf.cursor], size: 12, style: :bold
                last_measured_y = pdf.cursor
                pdf.move_down 12
                last_measured_y = pdf.cursor

  table3_header_data = [ 
    ["QUOTED BY:", "                          "],
    ["DATE QUOTED:", ""],
    ["FREIGHT QUOTE ID:", ""],
    ["FREIGHT QUOTE:", ""],
    ["FREIGHT CARRIER:", ""],
    ["METHOD OF DELIVERY:", ""]
  ]

  pdf.table(table3_header_data, :position => freight_table1_x, :width => 325, :cell_style => { :size => 12 }) do
    style(row(0..5).columns(0..1), :padding => [1, 5, 1, 5], :borders => [:top, :left, :right, :bottom])
    style(column(0), :align => :center)
  end


     pdf.move_cursor_to last_measured_y 


     	pdf.draw_text "DIRECT SHIP QUOTES REQUIRED FOR THE", :at => [340, pdf.cursor], size: 10, style: :bold
        pdf.move_down 10
     	pdf.draw_text "FOLLOWING-PLEASE SUBMIT SEPARATE", :at => [340, pdf.cursor], size: 10, style: :bold
        pdf.move_down 10
     	pdf.draw_text "QUOTE:", :at => [340, pdf.cursor], size: 10, style: :bold
        pdf.move_down 30
     	#pdf.draw_text "-Cantilever Shade Products", :at => [350, pdf.cursor], size: 9
        #pdf.move_down 10
     	pdf.draw_text "-Boulders (except for Raptor Head/Tail and Fossil Jan", :at => [340, pdf.cursor], size: 9
        pdf.move_down 10
     	pdf.draw_text "-TimberStacks", :at => [340, pdf.cursor], size: 9
        pdf.move_down 10
     	pdf.draw_text "Sculpted Play Items: Jungle Rock Link and Climber,", :at => [340, pdf.cursor], size: 9
        pdf.move_down 10
     	pdf.draw_text "Gorilla over Log, Blue Whale and Tail, LadyBug, Log", :at => [340, pdf.cursor], size: 9
        pdf.move_down 10
     	pdf.draw_text "Steps, Tree Log, Rabbit, Hammerhead Shark", :at => [340, pdf.cursor], size: 9
        pdf.move_down 10
     	pdf.draw_text "-Site Amenities (not ZZXX product)", :at => [340, pdf.cursor], size: 9

     end # end for quote table loop
 

#end # end bounding box for subtotal




end # Prawn ddo


