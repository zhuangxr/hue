import os

from django.core.management.base import BaseCommand

from desktop import conf

from tornado import httpserver, web, wsgi,\
                    ioloop, netutil, process


DEFAULT_STATIC_PATH = os.path.join(os.getcwd(), 'static/prod')
SERVER_OPTIONS = {
  'host': conf.HTTP_HOST.get(),
  'port': conf.HTTP_PORT.get(),
  # 'server_name': 'localhost',
  # 'server_user': conf.SERVER_USER.get(),
  # 'server_group': conf.SERVER_GROUP.get(),
  # 'certfile': conf.SSL_CERTIFICATE.get(),
  # 'keyfile': conf.SSL_PRIVATE_KEY.get(),
  # 'ssl_cipher_list': conf.SSL_CIPHER_LIST.get()
}


class Command(BaseCommand):
  args = ''
  help = 'Start tornado server'

  def handle(self, *args, **kwargs):
    from django.core.wsgi import get_wsgi_application
    from django.conf import settings

    container = wsgi.WSGIContainer(get_wsgi_application())
    handlers = [
      ('.*', web.FallbackHandler, dict(fallback=container))
    ]
    application = web.Application(handlers)
    kwargs = {}
    sockets = netutil.bind_sockets(SERVER_OPTIONS['port'])
    process.fork_processes(8)
    server = httpserver.HTTPServer(application, **kwargs)
    server.add_sockets(sockets)
    ioloop.IOLoop.instance().start()
