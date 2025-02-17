//
// Created by caesar kekxv on 2021/9/22.
//

#include <curl/curl.h>
#include <cstdio>
#include <gtest/gtest.h>

bool getUrl(const char* filename)
{
  CURL* curl = nullptr;
  CURLcode res{};
  FILE* fp;
  if ((fp = fopen(filename, "w")) == nullptr) // 返回结果用文件存储
    return false;
  struct curl_slist* headers = nullptr;
  headers = curl_slist_append(headers, "Accept: Agent-007");
  curl = curl_easy_init(); // 初始化
  if (curl)
  {
    //curl_easy_setopt(curl, CURLOPT_PROXY, "10.99.60.201:8080");// 代理
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers); // 改协议头
    curl_easy_setopt(curl, CURLOPT_URL, "http://www.baidu.com");
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp); //将返回的http头输出到fp指向的文件
    curl_easy_setopt(curl, CURLOPT_HEADERDATA, fp); //将返回的html主体数据输出到fp指向的文件
    res = curl_easy_perform(curl); // 执行
    if (res != 0)
    {
      curl_slist_free_all(headers);
      curl_easy_cleanup(curl);
    }
    fclose(fp);
    return true;
  }
  return false;
}

bool postUrl(const char* filename)
{
  CURL* curl = nullptr;
  CURLcode res{};
  FILE* fp;
  if ((fp = fopen(filename, "w")) == NULL)
    return false;
  curl = curl_easy_init();
  if (curl)
  {
    curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "/tmp/cookie.txt"); // 指定cookie文件
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "&logintype=uid&u=xieyan&psw=xxx86"); // 指定post内容
    //curl_easy_setopt(curl, CURLOPT_PROXY, "10.99.60.201:8080");
    curl_easy_setopt(curl, CURLOPT_URL, " http://mail.sina.com.cn/cgi-bin/login.cgi "); // 指定url
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
    res = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    fclose(fp);
    return true;
  }
  return false;
}


TEST(getUrl, Empty)
{
  getUrl("https://kterminal.kekxv.com/");
}

TEST(postUrl, Empty)
{
  postUrl("https://kterminal.kekxv.com/");
}
