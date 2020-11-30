var $star_rating1 = $('.star-rating1 .fa');

var SetRatingStar = function () {
  return $star_rating1.each(function () {
    if (parseInt($star_rating1.siblings('input.rating-value1').val()) >= parseInt($(this).data('rating'))) {
      return $(this).removeClass('fa-star-o').addClass('fa-star');
    } else {
      return $(this).removeClass('fa-star').addClass('fa-star-o');
    }
  });
};

$star_rating1.on('click', function () {
  $star_rating1.siblings('input.rating-value1').val($(this).data('rating'));
  return SetRatingStar();
});

SetRatingStar();
$(document).ready(function () {

});