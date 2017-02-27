#!/bin/bash -v

source /etc/profile.d/dmc.sh
sudo yum -y install wget openjdk-8-jdk httpd php
cd /tmp
sudo rm *.rpm
sudo yum -y install https://s3.amazonaws.com/dmc-build-aritifacts/$release/front/rh_httpd24_shibsp-1.0.0-1.x86_64.rpm
echo export LD_LIBRARY_PATH=/opt/shibboleth-sp/lib | sudo tee -a /etc/sysconfig/httpd
# sudo cp /opt/shibboleth-sp/etc/shibboleth/apache22.conf /etc/httpd/conf.d
sudo cp /tmp/apache24.conf /etc/httpd/conf.d/apache24.conf
# sudo sed -e -i 's/mod_shib_22.so/mod_shib_24.so' /etc/httpd/conf.d/apache22.conf
# sudo sed -e -i 's/  ShibCompatWith24 On/' /etc/httpd/conf.d/apache22.conf
# sudo sed -e -i 's/  ShibRequestSetting requireSession 1/' /etc/httpd/conf.d/apache22.conf
sudo su -c "echo \"RewriteEngine on\" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"RewriteCond %{HTTP:X-Forwarded-Proto} ^http$\" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]\" >>  /etc/httpd/conf/httpd.conf"
sudo -u root -E sed -i "s@#ServerName www.example.com:80@ServerName https://$serverURL@" /etc/httpd/conf/httpd.conf
sudo -u root -E sed -i "s/UseCanonicalName Off/UseCanonicalName On/" /etc/httpd/conf/httpd.conf
sudo su -c "echo \"ProxyIOBufferSize 65536\" >>  /etc/httpd/conf/httpd.conf"
#ensure it outputs corectly


#this section blocks specific endpoints
sudo su -c "echo \"ProxyPass /rest/verify "\!" \" >>  /etc/httpd/conf/httpd.conf"


#this section allows explicit mappings for endpoints
sudo su -c "echo \"ProxyPass /rest/companies ajp://$restIp:8009/rest/companies \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/accountNotificationCategories ajp://$restIp:8009/rest/accountNotificationCategories \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/account-notification-settings/ ajp://$restIp:8009/rest/account-notification-settings/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/account_servers ajp://$restIp:8009/rest/account_servers \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/accounts/ ajp://$restIp:8009/rest/accounts/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/companies ajp://$restIp:8009/rest/companies \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/companies ajp://$restIp:8009/rest/companies \" >>  /etc/httpd/conf/httpd.conf"

#start of khai's changes

sudo su -c "echo \"ProxyPass /rest/companies ajp://$restIp:8009/rest/companies \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/accountNotificationCategories ajp://$restIp:8009/rest/accountNotificationCategories \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/account-notification-settings/ ajp://$restIp:8009/rest/account-notification-settings/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/account_servers ajp://$restIp:8009/rest/account_servers \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/accounts/ ajp://$restIp:8009/rest/accounts/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/announcements ajp://$restIp:8009/rest/announcements \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/appSubmission ajp://$restIp:8009/rest//appSubmission \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/appSubmission/appName ajp://$restIp:8009/rest/appSubmission/appName \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/assign_users ajp://$restIp:8009/rest/assign_users \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/error ajp://$restIp:8009/rest/error \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/companies/create ajp://$restIp:8009/rest/companies/create \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company/follow ajp://$restIp:8009/rest/company/follow \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company/unfollow/ ajp://$restIp:8009/rest/company/unfollow/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company_reviews ajp://$restIp:8009/rest/company_reviews \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company_featured/add ajp://$restIp:8009/rest/company_featured/add \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company_featured/ ajp://$restIp:8009/rest/company_featured/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company_key_contacts ajp://$restIp:8009/rest/company_key_contacts \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company_reviews_flagged ajp://$restIp:8009/rest/company_reviews_flagged \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company_reviews_helpful ajp://$restIp:8009/rest/company_reviews_helpful \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/company_skills ajp://$restIp:8009/rest/company_skills \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/compare_services ajp://$restIp:8009/rest/compare_services \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/directories ajp://$restIp:8009/rest/directories \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/all-discussions ajp://$restIp:8009/rest/all-discussions \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/discussions/create ajp://$restIp:8009/rest/discussions/create \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiidocument ajp://$restIp:8009/rest/dmdiidocument \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiidocument/filetype ajp://$restIp:8009/rest/dmdiidocument/filetype \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiidocuments ajp://$restIp:8009/rest//dmdiidocuments \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiidocuments/dmdiiProjectId ajp://$restIp:8009/rest/dmdiidocuments/dmdiiProjectId \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiidocuments/getAllTags ajp://$restIp:8009/rest/dmdiidocuments/getAllTags \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiidocuments/saveDocumentTag ajp://$restIp:8009/rest/dmdiidocuments/saveDocumentTag \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/staticdocument/ ajp://$restIp:8009/rest/staticdocument/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiMember ajp://$restIp:8009/rest/dmdiiMember \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiMember/all ajp://$restIp:8009/rest/dmdiiMember/all \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiMember/events ajp://$restIp:8009/rest/dmdiiMember/events \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiMember/mapEntry ajp://$restIp:8009/rest/dmdiiMember/mapEntry \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiMember/news ajp://$restIp:8009/rest/dmdiiMember/news \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /dmdiiMember/save ajp://$restIp:8009/rest/dmdiiMember/save \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiMember/search ajp://$restIp:8009/rest/dmdiiMember/search \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiportalimage ajp://$restIp:8009/rest/dmdiiportalimage \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/contributingCompanies ajp://$restIp:8009/rest/contributingCompanies \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiProject/events ajp://$restIp:8009/rest/dmdiiProject/events \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiProject/news ajp://$restIp:8009/rest/dmdiiProject/news \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiProject/save ajp://$restIp:8009/rest/dmdiiProject/save \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiProject/ ajp://$restIp:8009/rest/dmdiiProject/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiProjectUpdate ajp://$restIp:8009/rest/dmdiiProjectUpdate \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiProjects/ ajp://$restIp:8009/rest/dmdiiProjects/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiproject/contributingcompanies ajp://$restIp:8009/rest/dmdiiproject/contributingcompanies \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiprojects ajp://$restIp:8009/rest/dmdiiprojects \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiprojects/awardDate ajp://$restIp:8009/rest/dmdiiprojects/awardDate \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiprojects/member ajp://$restIp:8009/rest/dmdiiprojects/member \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiprojects/member/active ajp://$restIp:8009/rest/dmdiiprojects/member/active \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiprojects/search ajp://$restIp:8009/rest/dmdiiprojects/search \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiquicklink ajp://$restIp:8009/rest/dmdiiquicklink \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dmdiiType ajp://$restIp:8009/rest/dmdiiType \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/documents ajp://$restIp:8009/rest/documents \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/documents/clone ajp://$restIp:8009/rest/documents/clone \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/documents/directories/ ajp://$restIp:8009/rest/documents/directories/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/documents/tags ajp://$restIp:8009/rest/documents/tags \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/documents/versions/ ajp://$restIp:8009/rest/documents/versions/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/getChildren ajp://$restIp:8009/rest/getChildren \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/getModel ajp://$restIp:8009/rest/getModel \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/dome-interfaces ajp://$restIp:8009/rest/dome-interfaces \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/events ajp://$restIp:8009/rest/events \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/faq_articles ajp://$restIp:8009/rest/faq_articles \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/faq_categories ajp://$restIp:8009/rest/faq_categories \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/faq_subcategories ajp://$restIp:8009/rest/faq_subcategories \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/favorite_products ajp://$restIp:8009/rest/favorite_products \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/follow_discussions ajp://$restIp:8009/rest/follow_discussions \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/follow_people_discussions ajp://$restIp:8009/rest/follow_people_discussions \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/following_discussions ajp://$restIp:8009/rest/following_discussions \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/following_members ajp://$restIp:8009/rest/following_members \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/individual-discussion-comments ajp://$restIp:8009/rest/individual-discussion-comments \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/individual-discussion-comments-flagged ajp://$restIp:8009/rest/individual-discussion-comments-flagged \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/individual-discussion-comments-helpful ajp://$restIp:8009/rest/individual-discussion-comments-helpful \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/individual-discussion ajp://$restIp:8009/rest/individual-discussion \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/individual-discussion-tags ajp://$restIp:8009/rest/individual-discussion-tags \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/input-positions ajp://$restIp:8009/rest/input-positions \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/market/components ajp://$restIp:8009/rest/market/components \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/market/new_services ajp://$restIp:8009/rest/market/new_services \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/market/popular_services ajp://$restIp:8009/rest/market/popular_services \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/market/services ajp://$restIp:8009/rest/market/services \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/notifications ajp://$restIp:8009/rest/notifications \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/organization/nonMember ajp://$restIp:8009/rest/organization/nonMember \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/organizations ajp://$restIp:8009/rest/organizations \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/popular_discussions ajp://$restIp:8009/rest/popular_discussions \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/product/{serviceId}/product_reviews ajp://$restIp:8009/rest/product/{serviceId}/product_reviews \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/product_reviews ajp://$restIp:8009/rest/product_reviews \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/product_reviews_flagged ajp://$restIp:8009/rest/product_reviews_flagged \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/product_reviews_helpful ajp://$restIp:8009/rest/product_reviews_helpful \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/profile_reviews ajp://$restIp:8009/rest/profile_reviews \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/profiles ajp://$restIp:8009/rest/profiles \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/review_replies/ ajp://$restIp:8009/rest/review_replies/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/profile_reviews_flagged ajp://$restIp:8009/rest/profile_reviews_flagged \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/profile_reviews_helpful ajp://$restIp:8009/rest/profile_reviews_helpful \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projectJoinApprovalRequests/ ajp://$restIp:8009/rest/projectJoinApprovalRequests/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects ajp://$restIp:8009/rest/projects \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects/all ajp://$restIp:8009/rest/projects/all \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects/create ajp://$restIp:8009/rest/projects/create \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects/createWithParameter ajp://$restIp:8009/rest/projects/createWithParameter \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects_join_requests ajp://$restIp:8009/rest/projects_join_requests \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/new_members/ ajp://$restIp:8009/rest/new_members/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects_members ajp://$restIp:8009/rest/projects_members \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/saveprojects_members/ ajp://$restIp:8009/rest/saveprojects_members/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects_tags ajp://$restIp:8009/rest/projects_tags \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/resource/assessment ajp://$restIp:8009/rest/resource/assessment \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/resource/bay ajp://$restIp:8009/rest/resource/bay \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/resource/course ajp://$restIp:8009/rest/resource/course \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/resource/job ajp://$restIp:8009/rest/resource/job \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/resource/lab ajp://$restIp:8009/rest/resource/lab \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/resource/machine ajp://$restIp:8009/rest/resource/machine \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/resource/project ajp://$restIp:8009/rest/resource/project \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/role/ ajp://$restIp:8009/rest/role/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/search/ ajp://$restIp:8009/rest/search/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/searchCompanies/ ajp://$restIp:8009/rest/searchCompanies/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/searchComponents/ ajp://$restIp:8009/rest/searchComponents/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/searchMembers/ ajp://$restIp:8009/rest/searchMembers/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/searchProjects/ ajp://$restIp:8009/rest/searchProjects/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/searchServices/ ajp://$restIp:8009/rest/searchServices/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/searchUsers/ ajp://$restIp:8009/rest/searchUsers/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/triggerFullIndexing/ ajp://$restIp:8009/rest/triggerFullIndexing/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/service_authors/service_authors ajp://$restIp:8009/rest/service_authors/service_authors \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/array_specifications ajp://$restIp:8009/rest/array_specifications \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/components/ ajp://$restIp:8009/rest/components/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/projects/ ajp://$restIp:8009/rest/projects/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/service/ ajp://$restIp:8009/rest/service/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/services ajp://$restIp:8009/rest/services \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/specifications/ ajp://$restIp:8009/rest/specifications/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/model_poll/ ajp://$restIp:8009/rest/model_poll/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/model_run ajp://$restIp:8009/rest/model_run \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/model_run_file ajp://$restIp:8009/rest/model_run_file \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/model_run_file1 ajp://$restIp:8009/rest/model_run_file1 \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/service_runs ajp://$restIp:8009/rest/service_runs \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/service_tags ajp://$restIp:8009/rest/service_tags \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/shared-services ajp://$restIp:8009/rest/shared-services \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/tags/dmdiiMember ajp://$restIp:8009/rest/tags/dmdiiMember \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/tags/organization ajp://$restIp:8009/rest/tags/organization \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/tasks ajp://$restIp:8009/rest/tasks \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/tasks/create ajp://$restIp:8009/rest/tasks/create \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/user-basic-information ajp://$restIp:8009/rest/user-basic-information \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/user ajp://$restIp:8009/rest/user \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/user/createtoken ajp://$restIp:8009/rest/user/createtoken \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/user/organization/ ajp://$restIp:8009/rest/user/organization/ \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/user/save ajp://$restIp:8009/rest/user/save \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/users ajp://$restIp:8009/rest/users \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/users/create ajp://$restIp:8009/rest/users/create \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/userRole ajp://$restIp:8009/rest/userRole \" >>  /etc/httpd/conf/httpd.conf"
sudo su -c "echo \"ProxyPass /rest/verify ajp://$restIp:8009/rest/verify \" >>  /etc/httpd/conf/httpd.conf"


#TODO this will blanket redirect should be removed when all the explicit routes are mapped
sudo su -c "echo \"ProxyPass /rest ajp://$restIp:8009/rest\" >>  /etc/httpd/conf/httpd.conf"


sudo sed -i "s/^error_reporting\s*=.*/error_reporting= E_ALL/" /etc/php.ini
sudo sed -i "s/^display_errors\s*=.*/display_errors = On/" /etc/php.ini
sudo sed -i "s/^display_startup_errors\s*=.*/display_startup_errors = On/" /etc/php.ini
sudo sed -i "s/^html_errors\s*=.*/display_html_errors = On/" /etc/php.ini
sudo sed -i "s/^log_errors\s*=.*/log_errors = On/" /etc/php.ini


sudo mkdir -p /var/www/html
cd /tmp


wget https://s3.amazonaws.com/dmc-build-aritifacts/$release/front/dist0117.tar.gz
rm -fr dist
mkdir dist
tar -xvzf dist0117.tar.gz -C dist

sudo cp -r /tmp/dist/dist/* /var/www/html
cd /var/www/html/templates/common/header
if [ $mode == development ] ; then
  echo "System is set up for Develpment Mode."
  sudo sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://dev-web1.opendmc.org/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html
else
  sudo sed -i.bak "s|loginURL|https://apps.cirrusidentity.com/console/ds/index?entityID=https://beta.opendmc.org/shibboleth\&return=https://$serverURL/Shibboleth.sso/Login%3Ftarget%3Dhttps%3A%2F%2F$serverURL|" header-tpl.html
  sudo sed -i.bak "s|dev-web1|beta|" /opt/shibboleth-sp/etc/shibboleth/shibboleth2.xml

fi


cd /var/www/html/scripts/common/models/
sudo sed -i.bak "s|  var creds = {bucket: '', access_key: '',secret_key: ''}|  var creds = {bucket: '$AWS_UPLOAD_BUCKET', access_key: '$AWS_UPLOAD_KEY',secret_key: '$AWS_UPLOAD_SEC'}|" file-upload.js
sudo sed -i.bak "s|    AWS.config.region = '';|    AWS.config.region = '$AWS_UPLOAD_REGION';|" file-upload.js
cd /var/www/html
sudo sed -i.bak "s|window.apiUrl = '';|window.apiUrl='https://$serverURL/rest'|" *.php
sudo chown -R apache:apache /var/www/html
 # sudo bash /opt/shibboleth-sp/etc/shibboleth/shibd-redhat start
 # sudo systemctl start httpd
sudo systemctl stop firewalld
sudo systemctl disable firewalld
