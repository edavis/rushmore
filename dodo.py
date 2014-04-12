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
            (html,) = node
            serialized = etree.tostring(
                html, method='html', pretty_print=True,
                doctype='<!doctype html>', encoding='utf-8')
            fp.write(serialized)

def task_build():
    return {
        'actions': [
            'xsltproc -o ericdavis_org.xml rushmore.xsl ericdavis_org.opml',
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
