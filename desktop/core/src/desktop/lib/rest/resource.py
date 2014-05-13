# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import ijson
import logging
import posixpath
import StringIO

LOG = logging.getLogger(__name__)


class JsonWrapper(object):
  def __init__(self, buf, prefix, event, value):
    # Maybe clone buffer
    self.buf = buf
    self.prefix = prefix
    self.event = event
    self.value = value

    # List items
    self.indexes = {}
    self.generators = {}

  def getListItem(self, key):
    key = int(key)
    new_prefix = "%s.item" % self.prefix

    # Start over
    if not self.generators.setdefault(new_prefix, {}) or self.generators[new_prefix]['index'] > key:
      self.generators[new_prefix]['generator'] = ijson.items(StringIO.StringIO(self.buf), "%s.item" % self.prefix)
      self.generators[new_prefix]['index'] = 0

    # Find index
    for item in self.generators[new_prefix]['generator']:
      if self.generators[new_prefix]['index'] == key:
        self.generators[new_prefix]['index'] += 1
        return item
      else:
        self.generators[new_prefix]['index'] += 1

    raise IndexError(key)

  def getMapItem(self, key):
    # String or unicode object
    if self.prefix:
      new_prefix = "%s.%s" % (self.prefix, key)
    else:
      new_prefix = key
    found_old_prefix = False
    for prefix, event, value in ijson.parse(StringIO.StringIO(self.buf)):
      if not found_old_prefix and prefix.startswith(self.prefix):
        found_old_prefix = True
      if found_old_prefix and not prefix.startswith(self.prefix):
        raise KeyError(key)
      elif prefix == new_prefix:
        return JsonWrapper(self.buf, prefix, event, value)
    raise KeyError(key)

  def __getitem__(self, key):
    try:
      return self.getListItem(key)
    except ValueError:
      return self.getMapItem(key)

  def __setitem__(self, key, value):
    NotImplementedError()

  def __delitem__(self, key):
    NotImplementedError()


class Resource(object):
  """
  Encapsulates a resource, and provides actions to invoke on it.
  """
  def __init__(self, client, relpath="", urlencode=True):
    """
    @param client: A Client object.
    @param relpath: The relative path of the resource.
    @param urlencode: percent encode paths.
    """
    self._client = client
    self._path = relpath.strip('/')
    self._urlencode = urlencode

  @property
  def base_url(self):
    return self._client.base_url

  def _join_uri(self, relpath):
    if relpath is None:
      return self._path
    return self._path + posixpath.normpath('/' + relpath)

  def _format_response(self, resp):
    """
    Decide whether the body should be a json dict or string
    """

    if len(resp.content) != 0 and resp.headers.get('content-type') and \
          'application/json' in resp.headers.get('content-type'):
      try:
        if 'FileStatuses' in resp.text:
          return JsonWrapper(resp.text, '', 'start_map', None)
        else:
          return resp.json()
      except Exception, ex:
        self._client.logger.exception('JSON decode error: %s' % resp.content)
        raise ex
    else:
      return resp.content

  def invoke(self, method, relpath=None, params=None, data=None, headers=None, allow_redirects=False):
    """
    Invoke an API method.
    @return: Raw body or JSON dictionary (if response content type is JSON).
    """
    path = self._join_uri(relpath)
    resp = self._client.execute(method,
                                path,
                                params=params,
                                data=data,
                                headers=headers,
                                allow_redirects=allow_redirects,
                                urlencode=self._urlencode)

    self._client.logger.debug(
        "%s Got response: %s%s" %
        (method, resp.content[:32], len(resp.content) > 32 and "..." or ""))

    return self._format_response(resp)


  def get(self, relpath=None, params=None, headers=None):
    """
    Invoke the GET method on a resource.
    @param relpath: Optional. A relative path to this resource's path.
    @param params: Key-value data.

    @return: A dictionary of the JSON result.
    """
    return self.invoke("GET", relpath, params, headers=headers, allow_redirects=True)


  def delete(self, relpath=None, params=None):
    """
    Invoke the DELETE method on a resource.
    @param relpath: Optional. A relative path to this resource's path.
    @param params: Key-value data.

    @return: A dictionary of the JSON result.
    """
    return self.invoke("DELETE", relpath, params)


  def post(self, relpath=None, params=None, data=None, contenttype=None):
    """
    Invoke the POST method on a resource.
    @param relpath: Optional. A relative path to this resource's path.
    @param params: Key-value data.
    @param data: Optional. Body of the request.
    @param contenttype: Optional. 

    @return: A dictionary of the JSON result.
    """
    return self.invoke("POST", relpath, params, data,
                       self._make_headers(contenttype))


  def put(self, relpath=None, params=None, data=None, contenttype=None):
    """
    Invoke the PUT method on a resource.
    @param relpath: Optional. A relative path to this resource's path.
    @param params: Key-value data.
    @param data: Optional. Body of the request.
    @param contenttype: Optional. 

    @return: A dictionary of the JSON result.
    """
    return self.invoke("PUT", relpath, params, data,
                       self._make_headers(contenttype))


  def _make_headers(self, contenttype=None):
    if contenttype:
      return { 'Content-Type': contenttype }
    return None
