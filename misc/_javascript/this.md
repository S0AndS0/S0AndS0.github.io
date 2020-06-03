---
layout: post
title: This
date: 2020-06-02 17:43:05 -0700
categories: posts
description: Examples and a bit of history about `this` keyword in JavaScript
---



Understanding `this` keyword can be a struggle, even for those that consider themselves experienced with JavaScript. The value of `this` keyword is dependent upon execution context, eg. global vs. function scope


> Note, it's totally okay to find `this` confusing, especially if reading code of someone that thinks they're clever.


Outside of a normal function `this` refers to the global object; for Browsers that'd be `window`...


```javascript
console.log(this === window);
//> true
```

... but for PDFs (if I remember correctly) `this` refers to `app`, and for NodeJS `this` is instead a `globalThis` reference. Furthermore, inside a function `this` can (though not always) refer to that function's execution scope; which depends upon how the function is called/instantiated and/or if `'use strict'` is defined...


```javascript
function f1() {
  return this;
}

f1() === window;
//> true


function f2() {
  'use strict';
  return this;
}

f2() === undefined;
//> true
```


> Side note, it's also okay to find `this` confusing even when reading code from those that are trying to be understood, because scoping can get more than a little weird in JavaScript.


------


Functions in JavaScript are Objects, and (a little bit of history) the `class` keyword is _syntactic sugar_ for a special kind of `function`. Here's one example of what authors had to write prior to the `class` keyword...


```javascript
function c1() {
  this.prop = 'spam';

  this.get_prop = function() {
    return this.prop;
  }
}

var classy_fn = new c1();
classy_fn.get_prop();
//> "spam"
```


> Note, things still must be written similar to above if programming PDF flavored JavaScript.
>
> Also note how `new` was used to instantiate a scope for the `c1` function.


... Here's how the above would be written with the newer `class` keyword...


```javascript
class c2 {
  constructor() {
    this.prop = spam;
  }

  get_prop() {
    return this.prop;
  }
}


var sugary_fn = new c2();
sugary_fn.get_prop();
//> "spam"
```


... again `new` was used because this tells the interpreter a new execution scope is to be created.


------


Functions as stated prior are Objects too, so `this` also can have special meaning within regular Objects too...


```javascript
var obj1 = {
  prop: 'spam',
  get_prop: function() {
    return this.prop;
  }
}

obj1.get_prop();
//> "spam"
```


> Note, however that `new` wasn't required for the `obj1` Object example.
>
> Also note, both `prop` and `get_prop` were assigned to `this` implicitly instead of the explicitly as in either Function or Class syntax.


... which can be good for some use cases, such as when execution context needs to be shared between multiple references of the same object, or when an author want's to _bum bits_ (AKA _code golf_) as it's sometimes called.


------


Both `c1` and `c2` are _functionally_ equivalent and in either case they're useful for defining a structure of shared data and/or functionality, for example here's how to write such that values can be passed into `this` context for a `function` based syntax...


```javascript
function classyNeuron(weights, bias, callback) {
  this.weights = weights;
  this.bias = bias;
  this.callback = callback;

  this.think = function(input) {
    return this.callback(this.weights, this.bias, input);
  }
}
```


... and for `class` based syntax it'd be sorta like...


```javascript
class sugaryNeuron {
  constructor(weights, bias, callback) {
    this.weights = weights;
    this.bias = bias;
    this.callback = callback;
  }

  think(input) {
    return this.callback(this.weights, this.bias, input);
  }
}
```


... then instantiating and using either would be similar to...


```javascript
var classy_neuron = new classyNeuron(
  [3.2, 0.5, 1.0],
  4.2,
  (weights, bias, input) => {
    return weights.reduce((accumulator, value) => {
      return accumulator + (value * input + bias);
    }, 0);
  }
);

classy_neuron.think(2);
//> 22
```


> Note, we're now introducing a different kind of function, known as an Arrow Function, with the `(value) => { return value * 2; }` syntax.


------


Arrow Functions slightly different than traditional Functions, for example `this` may still point to `window`...


```javascript
var arrow1 = () => {
  return this;
};

arrow1();
//> window
```


... however, when Arrow Functions are used within an Object scope, things are less well defined...


```javascript
var obj2 = {
  prop: 'spam',

  get_prop: () => {
    return this.prop;
  },

  whats_this: () => {
    return this;
  }
};


obj2.get_prop();
//> undefined
obj2.whats_this();
//> window
```


Funkier still, Arrow Functions do not have a implicit `constructor` method, so the following will fail with a `TypeError` when attempting to instantiate a new execution scope...


```javascript
var arrow2 = () => {
  this.prop = 'spam';
  this.get_prop = () => {
    return this.prop;
  };
};

var broken_arrow = new arrow2();
//> TypeError: arrow2 is not a constructor
```


... however, it's still possible to have `this` scoped predictably if Arrow Functions are defined within a traditional Function or Class...


```javascript
function c3() {
  this.prop = 'spam';

  this.get_prop = () => {
    return this.prop;
  }
}


class c4 {
  constructor() {
    this.prop = 'spam';

    this.get_prop = () => {
      return this.prop;
    };
  }
}
```


While possible to use Arrow Functions with `this` doing so is not advised, because there are edge cases that `this` doesn't _play nicely_ when compared to traditional Functions or Class Methods.


------


So far most of the cases I use `this` for have been covered, however, there are more tricks that `this` can do. Pull Requests are certainly welcome if any of the above is incorrect or could be better worded. For more advanced examples the links within the [Attribution][heading__attribution] section of this document may be worthwhile to review.


One more example for this post, here's one way that JavaScript could organize metadata about employees and shared functions to operate on said data...


First let's define a `class` that will structure the data and methods that will be useful to operate on the data regardless of employee...


```javascript
class Employee {
  /**
   * @param {string} name - name of employee
   * @param {string} dob - year-month-day Date of Birth
   * @param {number} hourly_wage - amount paid per hour
   */
  constructor(name, dob, hourly_wage) {
    this.hourly_wage = hourly_wage;
    this.dob = new Date(dob.split('-').map((value, index) => {
      // JavaScript months are 0 indexed, hence why for map and join
      if (index === 1) {
        return Number(value) - 1;
      }
      return Number(value);
    }).join('-'));
  }

  /**
   * @returns {number}
   */
  ageInYears() {
    const now = new Date();
    return now.getFullYear() - this.dob.getFullYear();
  }

  /**
   * @param {number} hours_worked - number of hours employee worked
   * @throws {TypeError} - if hours_worked is not a number
   * @returns {number}
   */
  wageFromHours(hours_worked) {
    if (isNaN(hours_worked)) {
      throw new TypeError('hours_worked is Not a Number');
    }
    return this.hourly_wage * hours_worked;
  }
}
```


... Next we can make a collection of employees...


```javascript
const employees = {
  bill: new Employee('Bill S, Preston ESQ', '1971-12-24', 7.5),
  joan: new Employee('Joan of Arc', '1431-05-30', 12.42),
  liz: new Employee('Elizabeth of York', '1466-02-11', 11.95),
  ted: new Employee('Ted Theodore Logan', '1969-01-06', 5.3),
};
```


... and assuming that each employee is paid a 40 hour salary, it is possible to utilize JavaScript to ask wage related questions and collect answers...


```javascript
// Assuming everyone works 40 hours
const weekly_wages = Object.entries(employees).reduce((accumulator, [key, employee]) => {
  accumulator[key] = employee.wageFromHours(40);
  return accumulator;
}, {});


const total_obligation = Object.entries(weekly_wages).reduce((accumulator, [key, wage]) => {
  return accumulator + wage;
}, 0);


console.log('Bill is owed', weekly_wages['bill']); //> 300
console.log('Joan is owed', weekly_wages['joan']); //> 496.8
console.log('Liz is owed', weekly_wages['liz']);   //> 478
console.log('Ted is owed', weekly_wages['ted']);   //> 212

console.log("Employer's total obligation", total_obligation);
//> 1486.8
```


... and it is also possible to apply functions over a collection of employees, such as obtaining who has birthdays within this month...


```javascript
function collectBirthdays(employees) {
  const now = new Date();
  return Object.entries(employees).reduce((accumulator, [key, employee]) => {
    if (now.getMonth() === employee.dob.getMonth()) {
      accumulator[key] = employee.dob;
    }
    return accumulator;
  }, {});
}


const months_birthdays = collectBirthdays(employees);
```


The JavaScript interpreter is able to keep each employee's date of birth, hourly wage, and other data independent of each-other, because `this` is a separate execution context for each new employee.


___


## Attribution
[heading__attribution]: #attribution "Links that where useful in understanding `this`"


- [Mozilla Developer -- `this`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this)

- [StackOverflow -- How does the “this” keyword work?](https://stackoverflow.com/questions/3127429/how-does-the-this-keyword-work)

- [YouTube -- Fireship -- What is THIS in JavaScript? in 100 seconds](https://www.youtube.com/watch?v=YOlr79NaAtQ)
