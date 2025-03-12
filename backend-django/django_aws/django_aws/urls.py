"""
URL configuration for django_aws project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path("", views.home, name="home")
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path("", Home.as_view(), name="home")
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path("blog/", include("blog.urls"))
"""

from django.contrib import admin
from django.urls import path
from django.contrib import admin
from django.urls import include, path
from django_aws.settings import DEBUG, MEDIA_URL, MEDIA_ROOT, STATIC_URL, STATIC_ROOT

from django.conf.urls.static import static
        
urlpatterns = [
    path("admin/", admin.site.urls),
    # path("api/", include(router.urls))
    path("api/", include("django_aws.todo.urls")),
]

admin.site.site_header = "Django AWS Admin Panel"

if DEBUG:  # Dev env media and static url > folder conf
    urlpatterns += static(MEDIA_URL, document_root=MEDIA_ROOT)
    urlpatterns += static(STATIC_URL, document_root=STATIC_ROOT)
else:  # Other env media and static url > folder conf
    urlpatterns += static(MEDIA_URL, document_root=MEDIA_ROOT)
    urlpatterns += static(STATIC_URL, document_root=STATIC_ROOT)
