#!/usr/bin/python2

from types import *
_dir = lambda o: o.__dict__.keys()

def _get_type_dict(object):
    # create a dict with keys: attr, instance, list
    type_dict = {'attr': [], 'instance': [], 'list': []}
    for membname in _dir(object):
        if membname == '__parent__':
            continue
        object_type = type(getattr(object, membname))
        if object_type == InstanceType:
            type_dict['instance'].append(membname)
        elif object_type == ListType:
            type_dict['list'].append(membname)
        else:
            type_dict['attr'].append(membname)
    return type_dict

def XML_printer(object, level=0, type_dict=None):
    INDENT=3
    descript = ''
    if type_dict is None:
        type_dict = _get_type_dict(object)

    if type_dict['attr']:
        for attr_name in type_dict['attr']:
            attr_value = getattr(object, attr_name)
            descript = descript + (' '+ attr_name +'="'+attr_value+'"')
    if level != 0:
        if type_dict['instance'] or type_dict['list']:
            descript = descript + '>\n'
        else:
            descript = descript + '/>\n'

    for instance_name in type_dict['instance']:
        instance = getattr(object, instance_name)
        descript = descript + (' '*level)+'<'+instance_name
        # look ahead to see if the next instance contains lists or instances
        nested_type_dict = _get_type_dict(instance)
        descript = descript + XML_printer(instance, level+INDENT,
                                          nested_type_dict)
        if nested_type_dict['instance'] or nested_type_dict['list']:
            descript = descript + (' '*level)+'</'+instance_name+'>\n'

    for list_name in type_dict['list']:
        inst_list = getattr(object, list_name)
        for instance in inst_list:
            descript = descript + (' '*level)+'<'+list_name
            nested_type_dict = _get_type_dict(instance)
            descript = descript + XML_printer(instance, level+INDENT,
                                              nested_type_dict)
            if nested_type_dict['instance'] or nested_type_dict['list']:
                descript = descript + (' '*level)+'</'+list_name+'>\n'

    return  descript


if __name__ == '__main__':
    import sys
    from gnosis.xml.objectify import XML_Objectify, EXPAT
    xml_obj = XML_Objectify(sys.argv[1], EXPAT)
    pyobj = xml_obj.make_instance()
    print XML_printer(pyobj)

