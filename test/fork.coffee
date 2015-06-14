if require?
  chai = require 'chai'
else
  chai = @chai
chai.should()
expect = chai.expect
if require?
  chaiAsPromised = require 'chai-as-promised'
else
  chaiAsPromised = @chaiAsPromised
chai.use chaiAsPromised
if require?
  sinon = require 'sinon'
  WorkerClient = require '../WorkerClient.js'
else
  sinon = @sinon
  WorkerClient = @WorkerClient

child_process = require 'child_process'

describe 'fork', ->
  client = null
  beforeEach ->
    worker = child_process.fork('./fork_server.js')
    client = new WorkerClient(worker, null, 'fork')
  it 'should work', ->
    client.request('test1', ['test', 1]).should.eventually.equal('ok')
    client.request('test1', 1).should.rejectedWith('ng')
