'use strict';
const Doit = require('./doit');

exports.handler = async (event) => {
    console.log('hello lambda');
    await Doit.doit();
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    return response;
};

