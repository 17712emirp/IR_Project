<%@page pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.*, javax.servlet.http.*, java.io.*, java.net.URLEncoder, java.net.URLDecoder, java.nio.file.Paths,
                org.apache.lucene.analysis.Analyzer, org.apache.lucene.analysis.TokenStream, org.apache.lucene.analysis.standard.StandardAnalyzer, 
                org.apache.lucene.analysis.th.ThaiAnalyzer, org.apache.lucene.document.Document, org.apache.lucene.index.DirectoryReader, 
                org.apache.lucene.index.IndexReader, org.apache.lucene.queryparser.classic.QueryParser, org.apache.lucene.queryparser.classic.ParseException, 
                org.apache.lucene.search.IndexSearcher, org.apache.lucene.search.Query, org.apache.lucene.search.ScoreDoc, 
                org.apache.lucene.search.TopDocs, org.apache.lucene.search.highlight.Highlighter, org.apache.lucene.search.highlight.InvalidTokenOffsetsException, 
                org.apache.lucene.search.highlight.QueryScorer, org.apache.lucene.search.highlight.SimpleHTMLFormatter, 
                org.apache.lucene.search.highlight.SimpleFragmenter, org.apache.lucene.store.FSDirectory" %>
<%!
    // Utility method to escape HTML special characters.
    public String escapeHTML(String s) {
        if(s == null) return "";
        s = s.replaceAll("&", "&amp;");
        s = s.replaceAll("<", "&lt;");
        s = s.replaceAll(">", "&gt;");
        s = s.replaceAll("\"", "&quot;");
        s = s.replaceAll("'", "&apos;");
        return s;
    }
%>
<%@include file="header.jsp"%>

<%
    // Initialize flags and variables
    boolean error = false;
    String indexName = indexLocation;
    IndexSearcher searcher = null;
    Query query = null;
    TopDocs hits = null;
    int numTotalHits = 0;
    int startindex = 0;
    int maxpage = 50;
    String queryString = null;
    String startVal = null;
    String maxresults = null;
    int thispage = 0;

    // Attempt to open the index
    try {
        IndexReader reader = DirectoryReader.open(FSDirectory.open(Paths.get(indexName)));
        searcher = new IndexSearcher(reader);
    } catch(Exception e) {
        error = true;
        // Log or handle error e.getMessage() if needed
    }

    // Choose the analyzer (using ThaiAnalyzer as per your logic)
    Analyzer analyzer = new ThaiAnalyzer();

    if (!error) {
        // Retrieve parameters from the request
        queryString = request.getParameter("query");
        startVal = request.getParameter("startat");
        maxresults = request.getParameter("maxresults");
        try {
            if(maxresults != null) {
                maxpage = Integer.parseInt(maxresults);
            }
            if(startVal != null) {
                startindex = Integer.parseInt(startVal);
            }
        } catch(Exception e) {
            // On parse failure, defaults will be used.
        }

        if(queryString == null || queryString.trim().equals("")) {
            throw new ServletException("No query specified.");
        }

        try {
            QueryParser qp = new QueryParser("contents", analyzer);
            query = qp.parse(queryString.trim());
        } catch(ParseException e) {
            error = true;
        }
    }

    if (!error && searcher != null) {
        thispage = maxpage;
        hits = searcher.search(query, maxpage + startindex);
        numTotalHits = Math.toIntExact(hits.totalHits.value());
        if(numTotalHits == 0) {
            error = true;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucene Search Results</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: auto;
            padding: 20px;
            background: #ffffff;
            
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            color: #333;
            background-color: #e7e5a9;
        }
        .error {
            color: #dc3545;
            text-align: center;
            font-weight: bold;
        }
        .results-container {
            display: flex;
            flex-direction: column;
            gap: 20px; /* spacing between each result */
            margin-top: 20px;
        }
        .search-result {
            background: #fff;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .search-top {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .search-number {
            font-weight: bold;
            color: #666;
        }
        .search-title {
            font-weight: 600;
            color: #333;
        }
        .highlight {
            background-color: #fff3cd;
            padding: 2px 4px;
            border-radius: 4px;
        }
        a {
            color: #28a745;
            text-decoration: none;
            font-weight: 600;
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
        }
        a:hover {
            text-decoration: underline;
        }
        .more-results {
            margin-top: 20px;
            text-align: right;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Search Results [of "<%=queryString %>"]</h2>

<%
    if (error) {
%>
    <div class="error">
<%
        if (searcher == null) {
%>
            ERROR opening the Index - contact sysadmin!
<%
        } else if (numTotalHits == 0) {
%>
            I'm sorry, I couldn't find what you were looking for.
<%
        } else {
%>
            An error occurred while processing your request.
<%
        }
%>
    </div>
<%
    } else {
        // Adjust the number of results if we're near the end
        if ((startindex + maxpage) > numTotalHits) {
            thispage = numTotalHits - startindex;
        }

        // Set up highlighter
        QueryScorer queryScorer = new QueryScorer(query);
        SimpleHTMLFormatter formatter = new SimpleHTMLFormatter("<b style='background-color:yellow'>", "</b>");
        Highlighter highlighter = new Highlighter(formatter, queryScorer);
        highlighter.setTextFragmenter(new SimpleFragmenter(100));
%>
    <div class="results-container">
<%
        for (int i = startindex; i < (thispage + startindex); i++) {
            Document doc = searcher.storedFields().document(hits.scoreDocs[i].doc);
            String doctitle = doc.get("title");
            String path = doc.get("path");
            if (path != null && path.startsWith("../webapps/")) {
                path = path.substring(10);
            }
            if (doctitle == null || doctitle.trim().equals("")) {
                doctitle = path;
            }
            String content = doc.get("contents");
            TokenStream tokenStream = analyzer.tokenStream("contents", content);
            String fragment = "";
            try {
                fragment = highlighter.getBestFragments(tokenStream, content, 2, "...");
            } catch (InvalidTokenOffsetsException e) {
                e.printStackTrace();
            }
%>
        <div class="search-result">
        <% 
            String url = doc.get("url");
            if (url != null) {
                if (url.endsWith(".html")) {
                  url = url.substring(0, url.length() - 5); // Remove ".html"
                } else if (url.endsWith(".htm")) {
                url = url.substring(0, url.length() - 4); // Remove ".htm"
                }
                else if(url.endsWith("/dummy")){
                	url = url.substring(0, url.length() - 6); // Remove "/dummy"
                }
            }
%>
            <div class="search-top">
                <div class="search-number"><%= i + 1 %>.</div>
                <div class="search-title"><%= escapeHTML(doctitle) %></div>
            </div>
            <div class="search-link">
                <a href="<%= url != null ? url : "#" %>" target="_blank">
                    ==> <%= url != null ? url : "No URL" %>
                </a>
            </div>
            <div class="search-snippet">
                <span class="highlight"><%= fragment %></span>
            </div>

            
        </div>
<%
        } // end for-loop

        // Check if there's a next page
        if ((startindex + maxpage) < numTotalHits) {
            String moreurl = "results.jsp?query=" + URLEncoder.encode(queryString, "UTF-8") +
                             "&amp;maxresults=" + maxpage +
                             "&amp;startat=" + (startindex + maxpage);
%>
    </div> <!-- end .results-container -->

    <div class="more-results">
        <a href="<%= moreurl %>">More Results &gt;&gt;</a>
    </div>
<%
        } else {
%>
    </div> <!-- end .results-container -->
<%
        } // end error-free branch
    } // end if-else error check
%>
</div>
</body>
</html>

