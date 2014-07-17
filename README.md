# madlib-promise-queue
[![Build Status](https://travis-ci.org/Qwerios/madlib-promise-queue.svg?branch=master)](https://travis-ci.org/Qwerios/madlib-promise-queue) [![NPM version](https://badge.fury.io/js/madlib-promise-queue.png)](http://badge.fury.io/js/madlib-promise-queue) [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)

[![Npm Downloads](https://nodei.co/npm/madlib-promise-queue.png?downloads=true&stars=true)](https://nodei.co/npm/madlib-promise-queue.png?downloads=true&stars=true)

A general purpose queue'ing mechanism using promises


## acknowledgments
The Marviq Application Development library (aka madlib) was developed by me when I was working at Marviq. They were cool enough to let me publish it using my personal github account instead of the company account. We decided to open source it for our mutual benefit and to ensure future updates should I decide to leave the company.


## philosophy
JavaScript is the language of the web. Wouldn't it be nice if we could stop having to rewrite (most) of our code for all those web connected platforms running on JavaScript? That is what madLib hopes to achieve. The focus of madLib is to have the same old boring stuff ready made for multiple platforms. Write your core application logic once using modules and never worry about the basics stuff again. Basics including XHR, XML, JSON, host mappings, settings, storage, etcetera. The idea is to use the tried and proven frameworks where available and use madlib based modules as the missing link.

Currently madLib is focused on supporting the following platforms:

* Web browsers (IE6+, Chrome, Firefox, Opera)
* Appcelerator/Titanium
* PhoneGap
* NodeJS


## installation
```bash
$ npm install madlib-promise-queue --save
```

## usage
```javascript
var Queue = require( "madlib-promise-queue" )

// Make a queue that can hold 1 item
// Default queue type is fifo (first in, first out)
// Alternate option is lifo (last in, first out)
//
var queue = new Queue( 1, "fifo" )

// Get a promise from the queue that will resolve when a slot is available
//
queueItem1 = queue.ready()
queueItem1.then( function()
{
    ...
    // Let the queue know we're done to free up a slot
    //
    queue.done()
    ...
} ).done()

// This 2nd queue item promise won't resolve until a spot is available in the queue
//
queueItem2 = queue.ready()
queueItem2.then( function()
{
    ...
    // Let the queue know we're done to free up a slot
    //
    queue.done()
    ...
} ).done()

// If you want to flush the current queue content (both running and waiting)
// you can call the flush method.
// All queue promises will be rejected with "flush" as it's payload
//
queue.flush()
```