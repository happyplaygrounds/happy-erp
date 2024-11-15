// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from "@rails/request.js";
//import Rails from "@rails/ujs"

export default class extends Controller {
	static values = { url: String };

  connect() {
	this.sortable = Sortable.create(this.element, {
		animation: 350,
      		ghostClass: "bg-gray-200",
		onEnd: this.end.bind(this),
		handle: "[data-sortable-handle]",
	});
  }

	  disconnect() {
    		this.sortable.destroy();
  		}

	end(event) {
		console.log(event)
		let { newIndex, item } = event;
		const id = event.item.dataset.id
		const quoteid = event.item.dataset.quoteid
		const data = new FormData()
		data.append("position", event.newIndex + 1)
		newIndex++;


		const url = this.urlValue.replace(":quoteid",quoteid).replace(":id",id)

		//const url = event.item.dataset["url"].replace(":quoteid",quoteid).replace(":id",id)
    		
		patch(url, {
      			body: JSON.stringify({ position: newIndex }),

		//Rails.ajax({
		//	url: this.data.get("url").replace(":quoteid",quoteid).replace(":id",id),
		//	type: 'PATCH',
		//	data: data
		});
       }
}
