var request = require('request');

console.log('args: ', process.argv);
if (process.argv.length < 4) {
    console.log('need 2 arguments');
    console.log('1st: score');
    console.log('2nd: user_id');
    return;
}

var arg_score = process.argv[2];
var arg_user_id = process.argv[3];

var options = {
  uri: 'http://localhost:4567/ranking',
  //uri: 'http://app-redis-practice.herokuapp.com/ranking',
  headers: {'Content-Type': 'application/json'},
  json: true,
  body: JSON.stringify({ score: arg_score, user_id: arg_user_id })
};

request.post(options, function(error, response, body){
  if (!error && response.statusCode == 200) {
    console.log(body.result);
  } else {
    console.log('error: '+ response.statusCode);
  }
});
