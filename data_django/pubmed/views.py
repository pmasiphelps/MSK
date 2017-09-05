
#from django.http import HttpResponse
from django.http import Http404
# from django.template import loader
from django.shortcuts import render
from .models import Abstract
from .models import Article


def index(request):
	all_abstracts = Abstract.objects.all()
	return render(request, 'pubmed/index.html', { 'all_abstracts' : all_abstracts })


#	template = loader.get_template('pubmed/index.html')
#	context = { 'all_abstracts' : all_abstracts }
#	return HttpResponse(template.render(context, request))


#	for abstract in all_abstract:
#		url = '/pubmed/' + str(pmid) + '/'
#		html += '<a href="' + rul +  '">' + abstract.title + '</a><br>'
# 	return HttpResponse(html)


def detail(request, pmid):
	try:
		article = Article.objects.get(pk = pmid)
	except Article.DoesNotExist:
		raise Http404("Article does not exist")
	return render(request, 'pubmed/detail.html', {'article' : article })








