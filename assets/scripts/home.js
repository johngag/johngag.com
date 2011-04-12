$(document).ready(function() {
	getFeeds();
	
	function getFeeds(){
		var argsCFTips = {
			action: "main.ajaxCftips"
		};
		
		var argsTumblr = {
			action: "main.ajaxTumblr"
		};
		
		getFeed(argsCFTips);
		getFeed(argsTumblr);
	}
	
	function getFeed(args){
		$.ajax({
			url: "index.cfm",
			data: args,
			dataType: "json",
			cache: false,
			success: updateFeeds
		});
	}
	
	function updateFeeds(data){
		var items = data.ITEMS;
		var l = items.length;
		if(data.TYPE=='cftips'){
			for(var i = 0; i < 11; i++){
				$('#cftips').append('<p><a href="' + items[i].LINK + '">' + items[i].TITLE + '</a></p>');
			}
			$('#cftips-loading').hide();
		}else if(data.TYPE=='tumblr'){
			for(var i = 0; i < 11; i++){
				$('#tumblr').append('<p><a href="' + items[i].LINK + '">' + items[i].TITLE + '</a></p>');
			}
			$('#tumblr-loading').hide();
		}
		//<p><a href="#local.feed.link#">#local.feed.title#</a></p>
	}
});
