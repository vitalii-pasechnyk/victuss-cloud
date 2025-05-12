
const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({
  region: process.env.AWS_REGION,
  apiVersion: "2012-08-10"
});

const tableName = process.env.TABLE_COURSES;

exports.handler = (event, context, callback) => {
  const params = {
    TableName: tableName,
    Key: {
      id: {
        S: event.id
      }
    },

  };
  dynamodb.getItem(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      callback(null, {
        id: data.Item.id.S,
        title: data.Item.title.S,
        watchHref: data.Item.watchHref.S,
        authorId: data.Item.authorId.S,
        length: data.Item.length.S,
        category: data.Item.category.S
      });
    }
  });
};

