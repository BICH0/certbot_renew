This script lets you get a mail with info about your certbot certify renewal<br>
<h1>Requirements</h1>
You need to have the following packages installed
<ul>
  <li>cron</li>
  <li>certbot</li>
</ul>
<h1>Installation</h1>
<h2>Automatic</h2>
You can use this command to download the script and create a crontab to execute it weekly<br>
!!! It's necessary to execute it as root<br>
<code>su root -c "curl https://raw.githubusercontent.com/BICH0/certbot_renew/main/certbot_renew.sh > /opt/certbot_renew.sh && chmod +x /opt/certbot_renew.sh && echo 30 5 * * */7 /opt/certbot_renew.sh"</code><br>
<h2>Manual install</h2>
If you want to install it manually just download <code>certbot_renew.sh</code> and create a crontab to execute it, keep in mind that you need to execute the script with root privileges as it needs to turn off/on your web server while updating certificates.
