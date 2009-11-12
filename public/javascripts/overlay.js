function DialogOverlay(content, container) {

	// Manage arguments and assign defaults, 
	if (typeof container == 'undefined' ) container = document.body;
	if (null == (this.container = $(container))) throw("container is not valid");

	// Assign instance variables
	this.content = content;
	this.overlay = new Element('div', { 'class': 'overlay' }).hide();
	this.dialog = new Element('div', { 'class': 'dialog' }).hide();

	// Hide the overlay when clicked. Ignore clicks on the dialog.
	Event.observe(this.overlay, 'click', this.hide.bindAsEventListener(this));
	//Event.observe(this.dialog, 'click',  function(event) { Event.stop(event) });
	
	// Insert the elements into the DOM
	this.dialog.insert(this.content);
	this.container.insert(this.overlay);
	this.container.insert(this.dialog);

	// Content may have been hidden if it is embedded in the page
	content.show();
	this.dialog.hide();
}

DialogOverlay.prototype.show = function() {
	new Effect.Appear(this.overlay, { duration: 0.5,  to: 0.8 });
	this.dialog.show();
	return this;
};
DialogOverlay.prototype.hide = function(event) {
	this.dialog.hide();
	this.overlay.hide();
	return this;
};
