$(function() {
  $('#speakbtn').on('click', function(){
    var q_word = $('.q_word').text();
    const uttr = new SpeechSynthesisUtterance();
    uttr.text = q_word;
    uttr.lang = "en-US";
    speechSynthesis.speak(uttr);
  });
});

$(function() {
  $('.speakbtn_index').on('click', function(){
    var number = $(this).val();
    var word = $('.' + 'word_' + number).text();
    var uttr = new SpeechSynthesisUtterance();
    uttr.text = word;
    uttr.lang = "en-US";
    speechSynthesis.speak(uttr);
  });
});


