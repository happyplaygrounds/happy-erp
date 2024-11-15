//import { Controller } from "@hotwired/stimulus"

//export default class extends Controller {
  //connect() {
    //this.element.textContent = "Hello World!"
  //}
//}
//

import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from '@rails/request.js'

export default class extends Controller {
  static targets = [ "productid","quantity",  "price", "weight", "description", "purchaseDisc", "buyout", "total", "totalCost", "vendorid" ]

  connect() {
	  console.log("ProductConnect1", this.element)
	  console.log("ProductConnect2", this.sourceTarget)
	  console.log("ProductConnect3", this.sourceTargets)
	  this.element[this.identifier] = this
	  console.log("ProductConnect4", this.element[this.identifier])
	  //document.querySelector('#linetotal').total.total()
  }

  //subtot() {
//	  console.log("subtot", this.sourceTargets)
  //}

  async productinfo() {

    console.log("got down in here productinfo top");

    const value = this.productidTarget.value
    const query = new URLSearchParams({ country: value })

         // async myMethod () {
  	// works const request = new FetchRequest('get', `http://localhost:3000/happy_products/productinfo?productid=${value}`)
  	const request = new FetchRequest('get', `http://localhost:3000/happy_products/productinfo?productid=${value}`, 
		{ responseKind: "json" },
		{ headers: "any"})
  	const response = await request.perform()
    		const body = await response.json
			  console.log("got here");
			  console.log("response", response);
  	if (response.ok) {
			  console.log("body",body);
			  console.log("body id",Object.values(body)[0]);
		          var productArray = Object.values(body)[0];
	                 }
	     if (productArray.length != 0)
	       {
	       //// var productArray = Object.values(data)[0];
	       console.log("ProductArray", productArray);
	       console.log("ProductArray List", productArray[0]['list_price']);
	       console.log("ProductArray Parse", productArray[0]['list_price']);
	       var weightFormat = parseFloat(productArray[0]['weight']).toFixed(2)
	       var priceFormat = parseFloat(productArray[0]['list_price']).toFixed(2)
	       if (productArray[0]['purchase_discount'] != 0) {
	       var buyoutFormat = ((1 - productArray[0]['purchase_discount']) *  productArray[0]['list_price']).toFixed(2)
               } else {
	       var buyoutFormat = parseFloat(productArray[0]['dealer_cost']).toFixed(2)
               }
	       var totalFormat = ( this.quantityTarget.value * productArray[0]['list_price'] ).toFixed(2)
	       var finalTotalFormat = this.format_number(totalFormat)
	       console.log("totalFormat", totalFormat);
	       console.log("finalTotalFormat", finalTotalFormat);
	       var totalCostFormat = ( this.quantityTarget.value *  ((1 - productArray[0]['purchase_discount']) *  productArray[0]['list_price'])).toFixed(2)
	       var finalTotalCostFormat = this.format_number(totalCostFormat)
	       productArray.forEach(product => {
			  console.log("product loop",product);
			  console.log("product id",product.id);
			  console.log("product price",product.list_price);
		  	  this.descriptionTarget.value = product.description;
		  	  this.weightTarget.value = weightFormat;
		  	  this.priceTarget.value = priceFormat;
		  	  this.purchaseDiscTarget.value = product.purchase_discount;
                          this.buyoutTarget.value = buyoutFormat;  
                          this.totalTarget.value = finalTotalFormat;  
                          this.totalCostTarget.value = totalCostFormat;  
                          this.vendoridTarget.value = product.happy_vendor_id;  
                          console.log("VendorID",product.happy_vendor_id);
		  });
                  console.log("productArray",productArray);
                  ////console.log("object 0",Object.values(data)[0].id);
                  //console.log(Object.values(data))
	       }
	    else
	    {
		  	  this.weightTarget.value = 0.0;
		  	  this.priceTarget.value = 0.0;
		  	  this.purchaseDiscTarget.value = 0.0;
                          this.buyoutTarget.value = 0.0;  
                          this.totalTarget.value = 0.0;  
                          this.totalCostTarget.value = 0.0;  
                          this.quantityTarget.value = 0.0;  
                          this.vendoridTarget.value = 1;  
                          console.log("NoVendorID",this.vendoridTarget.value);
	    }

    // Do whatever do you want with the response body
    // You also are able to call `response.html` or `response.json`, be aware that if you call `response.json` and the response contentType isn't `application/json` there will be raised an error.
			  console.log("test");
}

    //const value = this.productidTarget.value
    //fetch(`/happy_products/productinfo?productid=${value}`, {
      //headers: { accept: 'application/json'}
    //}).then((response) => {
	    //if (response.ok) {
		    //return response.json()
	    //} else {
		    //return Promise.reject('Infrastructure Error')
	            //console.log("Infrastructure Error");
	    //}
    //})
    //.then(data => {"data",console.log(data);
	     //var productArray = Object.values(data)[0];
	     //// if statement to zero out form fields when invalid part # and load when there is valid part #
	     //if (productArray.length != 0)
	       //{
	       //// var productArray = Object.values(data)[0];
	       //console.log("ProductArray", productArray);
	       //console.log("ProductArray List", productArray[0]['list_price']);
	       //console.log("ProductArray Parse", productArray[0]['list_price']);
	       //var weightFormat = parseFloat(productArray[0]['weight']).toFixed(2)
	       //var priceFormat = parseFloat(productArray[0]['list_price']).toFixed(2)
	       //if (productArray[0]['purchase_discount'] != 0) {
	       //var buyoutFormat = ((1 - productArray[0]['purchase_discount']) *  productArray[0]['list_price']).toFixed(2)
               //} else {
	       //var buyoutFormat = parseFloat(productArray[0]['dealer_cost']).toFixed(2)
               //}
	       //var totalFormat = ( this.quantityTarget.value * productArray[0]['list_price'] ).toFixed(2)
	       //var finalTotalFormat = this.format_number(totalFormat)
	       //console.log("totalFormat", totalFormat);
	       //console.log("finalTotalFormat", finalTotalFormat);
	       //var totalCostFormat = ( this.quantityTarget.value *  ((1 - productArray[0]['purchase_discount']) *  productArray[0]['list_price'])).toFixed(2)
	       //var finalTotalCostFormat = this.format_number(totalCostFormat)
	       //productArray.forEach(product => {
			  //console.log("product loop",product);
			  //console.log("product id",product.id);
			  //console.log("product price",product.list_price);
		  	  //this.descriptionTarget.value = product.description;
		  	  //this.weightTarget.value = weightFormat;
		  	  //this.priceTarget.value = priceFormat;
		  	  //this.purchaseDiscTarget.value = product.purchase_discount;
                          //this.buyoutTarget.value = buyoutFormat;  
                          //this.totalTarget.value = finalTotalFormat;  
                          //this.totalCostTarget.value = totalCostFormat;  
                          //this.vendoridTarget.value = product.happy_vendor_id;  
                          //console.log("VendorID",product.happy_vendor_id);
		  //});
                  //console.log("productArray",productArray);
                  ////console.log("object 0",Object.values(data)[0].id);
                  //console.log(Object.values(data))
	       //}
	    //else
	    //{
		  	  //this.weightTarget.value = 0.0;
		  	  //this.priceTarget.value = 0.0;
		  	  //this.purchaseDiscTarget.value = 0.0;
                          //this.buyoutTarget.value = 0.0;  
                          //this.totalTarget.value = 0.0;  
                          //this.totalCostTarget.value = 0.0;  
                          //this.quantityTarget.value = 0.0;  
                          //this.vendoridTarget.value = 1;  
                          //console.log("NoVendorID",this.vendoridTarget.value);
	    //}
    //})
     //.catch(error => console.log('Error is', error));
  //}

	format_number(field) {
	console.log("got in format");
	console.log(field.toLocaleString());
	console.log(parseFloat(field).toLocaleString());
	console.log(typeof field);

	var fieldType = (typeof field)

	var DecimalSeparator = Number("1.2").toLocaleString().substr(1,1);

	//var AmountWithCommas = field.toLocaleString();
	var AmountWithCommas = parseFloat(field).toLocaleString();


	var arParts = String(AmountWithCommas).split(DecimalSeparator);
	var intPart = arParts[0];
	var decPart = (arParts.length > 1 ? arParts[1] : '');
	decPart = (decPart + '00').substr(0,2);
	
	console.log("format", intPart + DecimalSeparator + decPart);

      return  (intPart + DecimalSeparator + decPart);
  }


}


