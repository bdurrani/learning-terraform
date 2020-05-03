'use strict';
const bent = require('bent');
const getJSON = bent('json')


class DoIt {

    static async doit() {
        let obj = await getJSON('https://jsonplaceholder.typicode.com/todos/1')
        console.log(obj);
    }
}

module.exports = DoIt;