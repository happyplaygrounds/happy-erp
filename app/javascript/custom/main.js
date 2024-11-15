$(document).on('turbo:load', function() {
	  //console.log('top remove');
	  //$('.js-basic-single').select2();
  $('#lineitems').on('cocoon:after-remove', function() {
	  console.log('after remove');
	  alert("you removed item");
  });

});

$(document).on('cocoon:after-remove', '.content', function(e, removedItem) {
  var myVar2=$( "input[name$='tax_amount]']" ).val();
  console.log("myVar2", myVar2);
	
  // Set tax amount to zero - NOT SURE THIS IS WORKING
  $("input[name$='tax_amount]']", removedItem).val(0);
  $("input[name$='taxable]']", removedItem).val(false);
  
  $(removedItem).remove('data-target');

   // Firing custom event to update tax amount COOL

        //const event = new CustomEvent("update-tax")
	//window.dispatchEvent(event)

  console.log($(removedItem));
  //$(removedItem).removeAttr('data-target');
 
  //$(removedItem).attr('data-target','destroy');

  console.log('after remove and update');
  console.log($(removedItem));

  //var testSum = removedItem.find('input[id$="total_line_amount"].val()');
  //console.log("TestSum", testSum);

  // Getting total line amount and removing data-target so stimulus igonore removed items

  var totalLineAmount = removedItem.find('input[id$="total_line_amount"]');
  console.log("totalLineAmount", totalLineAmount);

  var totalLineAmount2 = totalLineAmount.attr('id');
  console.log("totalLineAmount2", totalLineAmount2);

  console.log("This is IT", $(this));
  $(this).data('data-target', 'destroy');

	var myID=$( "input[id$='total_line_amount']" ).attr('id');
	console.log("myID", myID);

	$( "input[id=" + totalLineAmount2 + "]" ).attr('data-target','destroy');
	$( "input[id=" + totalLineAmount2 + "]" ).attr('class','commanumber');

  // Getting total line amount and removing data-target so stimulus igonore removed items

  var totalCostAmount = removedItem.find('input[id$="total_cost_amount"]');
  console.log("totalCostAmount", totalCostAmount);

  var totalCostAmount2 = totalCostAmount.attr('id');
  console.log("totalCostAmount2", totalCostAmount2);

	$( "input[id=" + totalCostAmount2 + "]" ).attr('data-target','destroy');
	$( "input[id=" + totalCostAmount2 + "]" ).attr('class','commanumber');

  var totalSum = 0;
  //$("input[id$='total_line_amount']" ).each(function() {
  var totalSum = 0;
  //$("input[id$='total_line_amount']" ).each(function() {
  $(".total_line_amount" ).each(function() {
	  totalSum += parseFloat($(this).val().replace(/,/g, ''));  
  });
  console.log("totalSum", totalSum);

  var totalCostSum = 0;
  //$("input[id$='total_cost_amount']" ).each(function() {
  $(".total_cost_amount" ).each(function() {
	  totalCostSum += parseFloat($(this).val().replace(/,/g, ''));  
  });
  console.log("totalCostSum", totalCostSum);

 var subtot = $(removedItem).find( "#quote_subtotals" );
 var totals = $(removedItem).find( ".commanumber" );
 var newsubtotal =  format_number(parseFloat(subtot.val().replace(/,/g, '')) - parseFloat(totals.val().replace(/,/g, '')));
 var newmargin =  ((totalSum - totalCostSum) / totalSum) * 100 

	function format_number(field) {
        //console.log(field.toLocaleString());
        //console.log(parseFloat(field).toLocaleString());
        //console.log(typeof field);

        var fieldType = (typeof field)

        var DecimalSeparator = Number("1.2").toLocaleString().substr(1,1);

        var AmountWithCommas = field.toLocaleString();


        var arParts = String(AmountWithCommas).split(DecimalSeparator);
        var intPart = arParts[0];
        var decPart = (arParts.length > 1 ? arParts[1] : '');
        decPart = (decPart + '00').substr(0,2);

      return  (intPart + DecimalSeparator + decPart);
      }
	  
  $( "input[id='quote_subtotals']" ).val(newsubtotal);
  $( "input[id='quote_margins']" ).val(newmargin.toFixed(2));
  var total = 0;
  		console.log("newsubtotals", newsubtotal);

  		console.log("subTotals", subtot.val().replace(/,/g, ''));
  		console.log("Totals", totals.val());
  		console.log("Totals math", parseInt(subtot.val().replace(/,/g, '')) - parseInt(totals.val().replace(/,/g, '')));
	        $('#quote_subtotals').each(function ( index ) {
			console.log($( this ) );
			console.log(index + ": " + $( this ).val() );
		});

	  totals.each(function(total) {
  		console.log("JTotal", total);
	});

  console.log("myvar2", myVar2);
  var myVar = $('quote_subtotals', removedItem).val();
  var quotesub = $('quote_subtotals', removedItem).val();
  console.log(myVar);
  console.log("this",$(this));
  console.log("quotesub",quotesub);
  console.log('Something');
  console.log(removedItem);
});


  // This loads product pricing and description
  // update 3/28/2023 below did nothing that i could tell but messed updating pricing for new part numbers

//$(function() {
//$(document).on('change', '[data-product]', function(e) {
   //$.ajax({
      //dataType: "json",
      //data: { product_id: $(this).val() },
      //success: function(data){
	 //document.getElementById("product_id").value = "My value";
         // Output returned data in form
      //}
   //});
//});
//});

  // This moves the page up after insert of new line item

$(document).on('cocoon:after-insert',  function(e, insertedItem) {
	console.log('After Insert Worked');
	var elmnt = document.getElementById("saveit");
	elmnt.scrollIntoView();
});
