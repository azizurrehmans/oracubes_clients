<mail id="a1" to="azizurehmans@gmail.com" subject="Results">
  <body srcType="text">
    Attached are quarterly results.
  </body>
  <foreach>
    <attach format="html" name="ppc_mp_ref.xml" srcType="report" instance="all">
      <include src="headerSection"/>
      <include src="mainSection"/>
    </attach>
  </foreach>
</mail>