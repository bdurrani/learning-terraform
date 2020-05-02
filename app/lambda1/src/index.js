'use strict';

exports.handler = async (event) => {
    console.log('hello lambda');
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    return response;
};

