from path import path
from lxml import etree

DOIT_CONFIG = {
    'default_tasks': ['build'],
}

def process_collection(xml, output):
    tree = etree.parse(xml)
    collection = tree.getroot()
    for node in collection:
        fname = node.attrib['path'].lstrip('/')
        p = path.joinpath(output, fname)
        if not p.parent.isdir():
            p.parent.makedirs_p()
        with p.open('w') as fp:
            (content,) = node
            params = {
                'pretty_print': True,
                'encoding': 'utf-8',
            }
            if p.endswith('.html'):
                params.update({
                    'method': 'html',
                    'doctype': '<!doctype html>',
                })
            elif p.endswith('.xml'):
                params.update({
                    'method': 'xml',
                    'xml_declaration': True,
                })
            serialized = etree.tostring(content, **params)
            fp.write(serialized)

def task_build():
    return {
        'actions': [
            """
            xsltproc -o ericdavis_org.xml \
                     --stringparam lastBuildDate "$(gdate -u +'%%a, %%b %%d %%Y %%R:%%S GMT')" \
                     rushmore.xsl ericdavis_org.opml
            """,
            'rm -rf html/*',
            (process_collection, ['ericdavis_org.xml', 'html']),
        ],
        'file_dep': ['ericdavis_org.opml', 'rushmore.xsl', 'templates.xsl'],
        'targets': ['ericdavis_org.xml'],
    }

def task_publish():
    return {
        'actions': [
            # 's3cmd -P -m text/xml put ericdavis_org.opml s3://ericdavis.org/',
            's3cmd -PM sync assets/ s3://files.davising.com/opml/',
            's3cmd -PM --delete-removed --exclude=".DS_Store" sync html/ s3://ericdavis.org/',
        ],
        'file_dep': ['ericdavis_org.xml', 'assets/base.css', 'assets/outline.js'],
        'verbosity': 2,
    }
