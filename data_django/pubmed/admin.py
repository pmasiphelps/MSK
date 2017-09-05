from django.contrib import admin

# Register your models here.

from .models import Abstract, Article, Gene, Variation

admin.site.register(Abstract)
admin.site.register(Article)
admin.site.register(Gene)
admin.site.register(Variation)


