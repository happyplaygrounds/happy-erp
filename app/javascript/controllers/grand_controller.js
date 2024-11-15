//import { Controller } from "stimulus"
//
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [  "quantity", "price", "buyout", "total", "subtot", "margin" ]

  connect() {
	  console.log("qty", this.quantityTarget.value)
	  console.log("price", this.priceTarget.value)
    if (this.quantityTarget.value && this.priceTarget.value) {
    	this.calculate()
    }
	  console.log("GrandHi", this.element)
	  console.log("GrandHi2", this.sourceTarget)
	  console.log("GrandHi3", this.sourceTargets)
	  this.element[this.identifier] = this
	  console.log("GrandHi4", this.element[this.identifier])
	  //document.querySelector('#linetotal').total.total()
  }
 

  calculate() {
    if (this.quantityTarget.value && this.priceTarget.value) {
  
    var subsum = 0;

    console.log("subsum top", subsum);

    var subtot = this.totalTargets;
    console.log("Grand1",subtot[0]);
    console.log("Grand2",subtot[1]);
    console.log("Grand3",subtot[2]);
    console.log("Grand4",subtot[3]);

    this.subtotTarget.value = this.totalTargets[0].value;

    //this.totalTargets.forEach( (elem) => { subsum = subsum + parseInt(elem.value) } )
    this.totalTargets.forEach( (elem) => { console.log(elem) } )
    this.totalTargets.forEach( (elem) => { subsum = subsum + parseFloat(elem.value.replace(/,/g, '')) } )

    this.subtotTargets.forEach( (elem) => { elem.value = this.format_number(subsum) } )
  
    console.log("subsum bottom", subsum);

    // Calculate overall quote margin

    
    // var quantity = this.quantityTargets.forEach( (elem) => { parseInt(elem.value) } )
    // var buyout = this.buyoutTargets.forEach( (elem) => { parseInt(elem.value) } )

    var quantity = this.quantityTargets
    var buyout = this.buyoutTargets

	  console.log("qty", quantity);
	  console.log("buyout", buyout);
 
    var quoteLen = quantity.length
	  console.log("quoteLen", quoteLen);

    var i=0;
    var totalCost=0;
    for (i=0; i < quoteLen; i++) {
	  console.log("loopqty", quantity[i].value);
	  totalCost = totalCost + (parseFloat(quantity[i].value) * parseFloat(buyout[i].value));
	  console.log("cost", totalCost);
     }

	  console.log("finalcost", totalCost);
	  console.log("finalSale", subsum );
	  var totalMargin = ((subsum - totalCost) / subsum) * 100;

	  if (Number.isNaN(totalMargin)) {
		  totalMargin = 0
	  }

	  console.log("finalMargin", totalMargin );
	  console.log("finalMargin2", totalMargin.toFixed(2) );

          this.marginTargets.forEach( (elem) => { elem.value = totalMargin.toFixed(2) } )
	  this.marginTargets.value = totalMargin.toFixed(2)
    
    console.log("length",this.totalTargets.length);
    console.log("Grand0val",this.totalTargets[0].value);
    //console.log("Grand1val1",this.totalTargets[1].value);
    console.log("Grand2",subtot[1]);

    //this.subtotalTarget.value = this.format_number(Total);

    console.log(this.application.getControllerForElementAndIdentifier(this.element, "total"));

  }
 
 } // if to check values of qty and price at start

  format_number(field) {
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
}
