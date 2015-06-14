chai = @chai
chai.should()
expect = chai.expect
chaiAsPromised = @chaiAsPromised
chai.use chaiAsPromised
sinon = @sinon
WorkerClient = @WorkerClient

describe 'webworker', ->
  client = null
  beforeEach ->
    worker = new Worker('./webworker_server.js')
    client = new WorkerClient(worker, null, 'webworker')
  it 'should work', ->
    client.request('test1', ['test', 1]).should.eventually.equal('ok')
    client.request('test1', 1).should.rejectedWith('ng')
