// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage

//= require jquery3
//= require jquery_ujs
//= require turbolinks

//= require Chart.bundle
//= require chartkick

//= require popper
//= require bootstrap
//= require_tree .



$( document ).ready(function() {
  getInputForUpdateProjectsName();
  
  
  var ranges = document.getElementsByClassName("rangeInput");
  var lables = document.getElementsByClassName("rangeText");
  console.log(ranges);
  console.log(lables);
  
  //var i;
  //for (i = 0; i < ranges.length; i++) {
  //  var oneOf = ranges[i];
  //  var oneLab = lables[i];
  //  updateText(oneOf, oneLab);
  //}
  
  
  var i;
  for (i = 0; i < ranges.length; i++) {
    var oneOf = ranges[i];
    var oneLab = lables[i];
    showSliderValue(oneOf, oneLab);
  }
  
  


});


function showSliderValue(oneOf, oneLab) {
  var rangeValues =
    {
      "-8": "1/9",
      "-7": "1/8",
      "-6": "1/7",
      "-5": "1/6",
      "-4": "1/5",
      "-3": "1/4",
      "-2": "1/3",
      "-1": "1/2",
      "0": "1",
      "1": "2",
      "2": "3",
      "3": "4",
      "4": "5",
      "5": "6",
      "6": "7",
      "7": "8",
      "8": "9"
    };
  oneOf.addEventListener('input',function(){
    var value = rangeValues[$(this).val()]
    //oneLab.innerHTML = oneOf.value;
    //var bulletPosition = (oneOf.value /oneOf.max);
    oneLab.innerHTML = value;
    var bulletPosition = (200 + oneOf.value*25);
    console.log(bulletPosition);
    oneLab.style.left = (bulletPosition) + "px";
  });

}



function updateText(oneOf, oneLab) {
  var rangeValues =
    {
      "-8": "1/9",
      "-7": "1/8",
      "-6": "1/7",
      "-5": "1/6",
      "-4": "1/5",
      "-3": "1/4",
      "-2": "1/3",
      "-1": "1/2",
      "0": "1",
      "1": "2",
      "2": "3",
      "3": "4",
      "4": "5",
      "5": "6",
      "6": "7",
      "7": "8",
      "8": "9"
    };
  
  oneOf.addEventListener('click',function(){
    var value = rangeValues[$(this).val()]
    oneLab.innerHTML = value;
    console.log(oneOf.value);
    console.log(oneLab);
  });
  
};





function getInputForUpdateProjectsName(){
  $('.edit-project-name-button').click(function() {
    var index = $('.edit-project-name-button').index(this);
    getOneInputUpdate(index);
  });
};

function getOneInputUpdate(index) {
  $('.show_project_name').eq( index ).hide();
  $('.change_project_name').eq( index ).css('display', 'inline-block');
};
