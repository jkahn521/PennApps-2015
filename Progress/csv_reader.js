csv_reader = new function(){

    var me = this;
    me.ready = false;
    me.debug = true;
    me.data = new Array();

    me.readFileEvent = function(event){

    