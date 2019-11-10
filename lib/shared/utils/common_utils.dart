
//将毫秒转化为格式化后的分秒(mm:ss)
String formatMath(int i) {
  String s = (i/1000/60).toString();
  return s.substring(0,(s.indexOf('.')+3)).replaceAll('.', ':');
}