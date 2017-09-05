# pubmed/urls.py
from django.conf.urls import url
from . import views

urlpatterns = [
	# /pubmed/
    url(r'^$', views.index, name='index'),

    # /pubmed/2100031
    url(r'^(?P<pmid>[0-9]+)/$', views.detail, name='detail'),
]
