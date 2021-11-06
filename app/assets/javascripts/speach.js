$(function() {
  $('#speakbtn').on('click', function(){
    const q_word = $('.q_word').text();
    const uttr = new SpeechSynthesisUtterance();
    uttr.text = q_word;
    uttr.lang = "en-US";
    speechSynthesis.cancel();
    speechSynthesis.speak(uttr);
  });
});

$(function() {
  $('.speakbtn_index').on('click', function(){
    const number = $(this).val();
    const word = $('.' + 'word_' + number).text();
    const uttr = new SpeechSynthesisUtterance();
    uttr.text = word;
    uttr.lang = "en-US";
    speechSynthesis.cancel();
    speechSynthesis.speak(uttr);
  });
});


