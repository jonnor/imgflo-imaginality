# Input data
# TODO: allow to change live?

evensteps = (start, stop, n) ->
  diff = stop - start
  step = diff / n
  out = []
  i = 0
  while i < n
    o = start + step * i
    out.push o
    i++
  out

###
    A more general model would perhaps be:
    - have a list of dimensions, of type
    (ranged-scalar, ranged-point, enumeration, rgbcolor/ranged-3dpoint)
    could be introspected from graph/runtime data

###

generateCardData = ->
  images = [
    'http://tctechcrunch2011.files.wordpress.com/2015/01/happy-kitten-kittens-5890512-1600-1200.jpg'
    'https://s3-us-west-2.amazonaws.com/the-grid-img/p/ae0ae224cf912fa51a92b5915ed9440b54617e1a.jpg'
    'https://s3-us-west-2.amazonaws.com/the-grid-img/p/aabbbf8d55648167302cb3e67666a1c4b1c9a6f7.jpg'
    'http://hivemodern.com/public_resources/eames-lounge-chair-ottoman-charles-and-ray-eames-herman-miller-1.jpg'
  ]
  data = []
  # For now simple 2d grid over one val
  evensteps(10, 100, 3).forEach (val, y) ->
    data[y] = []
    images.forEach (url, x) ->
      # annoying there are two
      # FIXME: hardcoded properties for a given graph
      props = 
        'input': url
        'std-dev-x': val
        'std-dev-y': val
      data[y][x] =
        id: x.toString() + '-' + y.toString()
        properties: props
      return
    return
  console.log data
  data

# User interface

iterate2dCards = (cards, itemcallback) ->
  cards.forEach (row, x) ->
    row.forEach (card, y) ->
      callback card, x, y
    return
  return

# TODO: separate more strongly between data for cards and how they are presented

setupImages = (container, cards) ->
  images = []
  columns = cards.length
  rows = cards[0].length

  div = (klass, parent) ->
    e = document.createElement('div')
    e.className = klass
    parent.appendChild e
    e

  table = div('table', container)
  cards.forEach (r, y) ->
    row = div('tr', table)
    r.forEach (card, x) ->
      cell = div('td', row)
      img = document.createElement('img')
      img.className = 'image'
      img.id = card.id
      img.hack_properties = card.properties
      cell.appendChild img
      images.push img
      return
    return
  images

# For imgflo-server
# TODO: use the-grid/imgflo-url library here?

createRequestUrl = (graphname, parameters, apiKey, apiSecret) ->
  hasQuery = Object.keys(parameters).length > 0
  search = graphname + (if hasQuery then '?' else '')
  for key of parameters
    value = encodeURIComponent(parameters[key])
    search += key + '=' + value + '&'
  if hasQuery
    search = search.substring(0, search.length - 1)
    # strip trailing &
  url = '/graph/' + search
  if apiKey or apiSecret
    token = CryptoJS.MD5(search + apiSecret)
    url = '/graph/' + apiKey + '/' + token + '/' + search
  url

# TODO: make this a class, emitting events on state changes, allowing re-processing

process = (images, graph, server, key, secret, done) ->
  # Curretly processing image elements using imgflo-server
  # FIXME: use imgflo runtime directly instead
  images.forEach (img) ->
    params = img.hack_properties
    img.src = server + createRequestUrl(graph, params, key, secret)
    return
  # FIXME: wait for .onload events
  done()

main = ->

  id = (n) ->
    document.getElementById n

  console.log 'running'

  data = generateCardData()
  images = setupImages(id('cards'), data)
  apiConfig = 
    key: null
    secret: null
    server: 'http://localhost:8080'
  # API info

  readApiInfo = ->
    id('apiKey').value = localStorage['imgflo-server-api-key'] or ''
    id('apiSecret').value = localStorage['imgflo-server-api-secret'] or ''
    return

  readApiInfo()

  id('clearApiInfo').onclick = ->
    localStorage['imgflo-server-api-key'] = ''
    localStorage['imgflo-server-api-secret'] = ''
    readApiInfo()
    return

  saveApiInfo = ->
    localStorage['imgflo-server-api-key'] = id('apiKey').value
    localStorage['imgflo-server-api-secret'] = id('apiSecret').value
    return

  id('apiKey').onblur = saveApiInfo
  id('apiSecret').onblur = saveApiInfo
  # multi-dimensional-view-thing
  # TODO: allow to trigger without reloading page
  # FIXME: make server configurable, persist like keys
  # TODO: capture server/key/secret into config object
  id('status').innerHTML = 'working'
  apiConfig.key = localStorage['imgflo-server-api-key']
  apiConfig.secret = localStorage['imgflo-server-api-secret']
  process images, 'gaussianblur', apiConfig.server, apiConfig.key, apiConfig.secret, ->
    id('status').innerHTML = 'done'
    return
  return

main()

