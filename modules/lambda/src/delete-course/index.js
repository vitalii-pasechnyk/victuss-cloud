const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({
  region: process.env.AWS_REGION,
  apiVersion: "2012-08-10"
});

exports.handler = (event, context, callback) => {
  const params = {
    
    TableName: process.env.TABLE_COURSES,

    Key: {
      id: {
        S: event.id
      }
    },
  };
  dynamodb.deleteItem(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      callback(null, data);
    }
  });
};

