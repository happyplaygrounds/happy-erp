//import { Controller } from "stimulus"
//
import { Controller } from "@hotwired/stimulus"

export default class TotalController extends Controller {
  static targets = [ "quantity", "price", "total", "purchaseDisc", "buyout", "totalCost", "margin", "subtotal","taxable", "taxAmount", "remove" ]

  connect() {

    	this.recalculate()
	  console.log("Hi", this.element)
	  console.log("Hi2", this.sourceTarget)
	  console.log("Hi3", this.totalTargets)
//	  this.element[this.identifier] = this
	  console.log("Hi4", this.element[this.identifier])
//	  document.querySelector('#linetotal').total.total()
  }

  sumitup(){
	  console.log("Got here1")
	  this.grandController.subtot()
  }

  get grandController() {
	  console.log("Got here2")
	  console.log("Got here3", this.element)
	  return this.application.getControllerForElementAndIdentifier(this.element, "grand")
  }

  setTaxAmount() {
    if (this.taxableTarget.checked) {
       this.taxAmountTarget.value = this.totalTarget.value
       console.log("taxtop", this.taxAmountTarget.value)
       console.log("checkedtop", this.taxableTarget)
    } else
	   {
       		this.taxAmountTarget.value = 0
	   }

  }
	
  recalculate() {
   if (this.quantityTarget.value && this.priceTarget.value) {

    console.log("Got here8", this.subtotalTarget.value)

    if (this.purchaseDiscTarget.value == null || Number.isNaN(this.purchaseDiscTarget.value)) {
	    this.purchaseDiscTarget = 0;
    } else {
	   if (this.purchaseDiscTarget.value != 0 && this.buyoutTarget.value == 0) {
	   //if (this.purchaseDiscTarget.value != 0) {
    	   var buyoutPrice = ((1 - this.purchaseDiscTarget.value) * this.priceTarget.value)
           this.buyoutTarget.value = buyoutPrice.toFixed(2)
           //this.buyoutTarget.value = Math.round((buyoutPrice + Number.EPSILON) * 100) /100;
	   }
    }

     // Parse out commas for priceTarget and buyoutTarget then use variables
    var unit_price = 0
    var unit_cost = 0
    var unit_price = (parseFloat(this.priceTarget.value.replace(/,/g, '')))
    var unit_cost =  (parseFloat(this.buyoutTarget.value.replace(/,/g, '')))

    //var Total = (this.quantityTarget.value * this.priceTarget.value)
    //var Total = (this.quantityTarget.value * (parseFloat(this.priceTarget.value.replace(/,/g, ''))))
    var Total = (this.quantityTarget.value * unit_price)

    this.totalTarget.value = this.format_number(Total);
 
    if (this.taxableTarget.checked) {
       //this.taxAmountTarget.value = Total
       //this.taxAmountTarget.value = this.totalTarget.value 
       this.taxAmountTarget.value = (parseFloat(this.totalTarget.value.replace(/,/g,''))); 
       console.log("taxtop", this.taxAmountTarget.value)
       console.log("checkedtop", this.taxableTarget)
    } else
	   {
       		this.taxAmountTarget.value = 0
	   }
       
       // Firing custom event to update tax amount

        const event = new CustomEvent("update-tax")
	window.dispatchEvent(event)

       console.log("bottom", this.taxAmountTarget.value)
       console.log("checkedbottom", this.taxableTarget)

    //var totalCost = (this.quantityTarget.value * this.buyoutTarget.value)
    //var totalCost = (this.quantityTarget.value * (parseFloat(this.buyoutTarget.value.replace(/,/g, ''))))
    var totalCost = (this.quantityTarget.value * unit_cost)

    if (Number.isNaN(totalCost)) {
	    totalCost = 0
	   }
    
    this.totalCostTarget.value = this.format_number(totalCost);
  

    //var Margin = ((this.priceTarget.value - this.buyoutTarget.value) / this.priceTarget.value) * 100;
    var Margin = ((unit_price - unit_cost) / unit_price) * 100;

    console.log("Margin", Margin)
	
    console.log(this.application.getControllerForElementAndIdentifier(this.element, "total"));


    
    if (Margin == null || Number.isNaN(Margin)) {
	    Margin = 0;
    }

    this.marginTarget.value = Margin.toFixed(2)
  }
 } //if recalculate

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
