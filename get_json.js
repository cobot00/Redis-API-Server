var request = require('request');

var options = {
  uri: 'http://localhost:4567/ranking',
  //uri: 'http://app-redis-practice.herokuapp.com/ranking',
  json: true
};

request.get(options, function(error, response, body){
  if (!error && response.statusCode == 200) {
    console.log(body);
  } else {
    console.log('error: '+ response.statusCode);
  }
});
