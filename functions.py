# functions
def write_list(input_list:list,filename:str):
    """
    saves a list (input_list) to a txt file (filename), no return values 
    """    
    open(filename,'w').writelines('\n'.join(input_list))  
def open_list(filename:str,output_list:list):
    """
    opens a txt file (filename) into a pre-defined list (output_list), appended list is returned 
    """    
    for line in open(filename, 'r'):
        output_list.append(line.replace('\n',''))   
