$(function() {
    $('li.has-children > i').click(function() {
	var $ul = $(this).next();
	if ($ul.is(':visible')) {
	    $(this).removeClass('fa-caret-down').addClass('fa-caret-right');
	} else {
	    $(this).removeClass('fa-caret-right').addClass('fa-caret-down');
	}
	$ul.toggle();
    });

    $('.created').each(function(idx, element) {
	var timestamp = moment.utc($(this).text(), 'ddd, DD MMM YYYY HH:mm:ss Z');
	$(this).text(timestamp.local().format('ddd, DD MMM YYYY hh:mm:ss A ZZ'));
    });
});
